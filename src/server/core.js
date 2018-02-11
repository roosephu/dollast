import { debug } from 'debug'
import { join, extname, basename, dirname } from 'path'
import options from '../common/options'
import { exec } from 'mz/child_process'
import * as fs from 'fs-extra'
import config from './config'
import tmp from 'tmp'
import { inspect } from 'util'
import * as _ from 'lodash'

const log = debug('dollast:core')

export async function compile (tmpDir, lang, code) {
  const srcPath = join(tmpDir, `/main${options.langSuffix[lang]}`)
  const exePath = join(tmpDir, '/main')
  await fs.writeFile(srcPath, code)
  const compileCmd = options.compileFmt[lang](srcPath, exePath)
  log(`compile command: ${compileCmd}}`)
  await exec(compileCmd)
  return exePath
}

function pairFiles (files) {
  const extType = {}
  for (const suf of ['ans', 'out']) {
    extType['.' + suf] = 'answer'
  }
  for (const suf of ['in', 'inp', 'inf']) {
    extType['.' + suf] = 'input'
  }

  const buckets = {}
  const excessive = []

  for (const file of files) {
    const ext = extname(file)
    const base = basename(file, ext)
    // log({ ext, base })
    if (extType[ext] !== undefined) {
      if (buckets[base] === undefined) {
        buckets[base] = {}
      }
      buckets[base][extType[ext]] = file
    } else {
      excessive.push(file)
    }
  }

  const pairs = []

  // log({ buckets, files, values: Object.values(buckets), keys: Object.keys(buckets) })
  for (const exts of Object.values(buckets)) {
    // log({ exts })
    if (exts.input !== undefined && exts.answer !== undefined) {
      exts.weight = 1.0
      pairs.push(exts)
    } else {
      for (const key of exts.keys()) {
        excessive.push(key)
      }
    }
  }

  return { pairs, excessive }
}

export async function upload (pid, part) {
  const dataDir = join(config.dataDir, `/${pid}`)
  await fs.mkdirs(dataDir)

  const extName = extname(part.filename)
  const zipFile = tmp.fileSync({ postfix: extName })
  const tmpDir = tmp.dirSync()
  let ret = {}

  log(`upload ${part.filename} -> ${zipFile.name}`)

  try {
    // await streamToPromise(part.pipe, fs.createWriteStream, zipFile.name)
    // log({ part, name: zipFile.name })
    await new Promise((resolve, reject) => {
      part.stream.on('error', error => {
        reject(error)
      }).on('end', () => {
        resolve()
      }).pipe(fs.createWriteStream(zipFile.name))
    })
    const [stdout, stderr] = await exec(`7z e ${zipFile.name} -o${tmpDir.name} -y`)
  } catch (e) {
    log({ e })
  } finally {
    zipFile.removeCallback()
    ret = { status: 'OK' }
  }

  async function walk (dir) {
    const files = await fs.readdir(dir)
    // log({ files })

    const fileList = []
    for (const file of files) {
      const fullPath = join(dir, file)
      // log({ fullPath })
      if (fs.statSync(fullPath).isDirectory()) {
        await walk(fullPath)
      } else {
        fileList.push(file)
      }
    }

    const { pairs, excessive } = pairFiles(fileList)
    // log({ fileList, pairs })

    for (const pair of pairs) {
      const {input, answer} = pair
      async function move (file) {
        const old = join(dir, file)
        const now = join(dataDir, file)
        // log({ old, now })
        await fs.move(old, now, { clobber: true })
      }

      await move(input)
      await move(answer)
    }
  }

  await walk(tmpDir.name)
  await fs.remove(tmpDir.name)

  log(`unzip status: ${inspect(ret)}`)
  return ret
}

export async function deleteTestData (pid, filename) {
  filename = basename(filename)
  const filePath = join(config.dataDir, `/${pid}/`, filename)
  log(`delete ${filePath}`)
  await fs.unlink(filePath)
}

// export async function uploadImage

export async function genDataPairs (pid) {
  const dataDir = join(config.dataDir, `/${pid}/`)
  const files = await fs.readdir(dataDir)
  const { pairs, excessive } = pairFiles(files)
  return pairs
}

const testlibExitCodes = {
  0: 'ok',
  1: 'wa',
  2: 'pe',
  3: 'fail',
  6: 'unexpected'
}

function dropFirstLine (message) {
  return _.drop(message.split('\n'), 1).join('\n')
}

async function judgeResult (pid, inFile, outFile, ansFile, cfg) {
  let judger
  if (cfg.judger === 'custom') {
    judger = join(config.dataDir, `/${pid}/`, '/judge')
  } else {
    judger = join(config.judgerDir, `/${cfg.judger}`)
  }

  // log({
  //   inf: await fs.readFile(inFile),
  //   out: await fs.readFile(outFile),
  //   ans: await fs.readFile(ansFile)
  // })

  // log({ judger })

  let stdout
  let stderr
  try {
    [stdout, stderr] = await exec(`${judger} ${inFile} ${outFile} ${ansFile}`)
  } catch (e) {
    // log({ message: e.message })
    const messages = dropFirstLine(e.message)
    // log({ judger, stdout, stderr, messages })
    return {
      status: testlibExitCodes[e.code],
      score: 0,
      message: messages.trim()
    }
  }

  log({ stdout, stderr })

  let [status, ...message] = stderr.trim().split(' ')
  message = message.split(' ')
  return { status, score: 1, message }
}

async function runAtom (pid, lang, exePath, data, cfg) {
  // log({ pid, lang, exePath, data, cfg })
  const tmpFile = tmp.fileSync()
  const out = tmpFile.name
  const inf = join(config.dataDir, String(pid), data.input)
  const ans = join(config.dataDir, String(pid), data.answer)
  const execCmd = `"${config.sandboxer}" "${exePath}" ${cfg.timeLimit} ${cfg.spaceLimit} ${cfg.stackLimit} ${cfg.outputLimit} "${inf}" "${out}"`

  log({ execCmd })

  let [procOut, procErr] = await exec(execCmd, { cwd: dirname(config.sandboxer) })

  const exeRes = JSON.parse(procErr)
  log({ exeRes })

  if (exeRes.status !== 'OK') {
    tmpFile.removeCallback()
    return Object.assign(exeRes, data)
  }
  const judgeRes = await judgeResult(pid, inf, out, ans, cfg)
  tmpFile.removeCallback()
  return Object.assign(exeRes, Object.assign(judgeRes, data))
}

function calcProblemScore (results) {
  const ret = {
    time: 0,
    space: 0,
    score: 0
  }

  let sum = 0
  let ws = 0

  for (const [data, result] of results) {
    if (result.time) ret.time = Math.max(result.time, ret.time)
    if (result.space) ret.space = Math.max(result.space, ret.space)

    sum += data.weight * result.score
    ws += data.weight
  }
  if (ws) {
    ret.score = sum / ws
  } else {
    ret.score = 0
  }

  return ret
}

export async function judge (lang, code, config, doc) {
  log(`start judging, lang = ${lang}`)

  const tmpDir = tmp.dirSync({ unsafeCleanup: true })
  // log({ tmpDir })
  const pid = doc.problem
  let exePath

  try {
    exePath = await compile(tmpDir.name, lang, code)
  } catch (e) {
    const message = dropFirstLine(e.message)
    tmpDir.removeCallback()
    log(e)
    log('CE: ', message)

    doc.summary = { score: 0, status: 'CE', message }
    await doc.save()
    return { status: 'CE' }
  }

  try {
    const dataset = config.dataset
    delete config.dataset

    const results = await Promise.all(dataset.map(data => runAtom(pid, lang, exePath, data.toObject(), config)))
    log('writing back')
    log({ results })
    doc.results = results
    doc.summary = calcProblemScore(_.zip(dataset, results))
    doc.summary.status = 'finished'
    await doc.save()
  } catch (e) {
    log(e)
  } finally {
    tmpDir.removeCallback()
  }

  return { status: 'OK' }
}
