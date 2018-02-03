// import pairFiles from '../../src/server/core.js'
import { debug } from 'debug'

const log = debug('dollast:test:core')

function pairFiles (files, rule) {
  const {inf, ans} = rule

  const dict = files.reduce((obj, val) => {
    obj[val] = true
    return obj
  }, {})

  const pairs = []
  for (const inputFile of files) {
    if (inputFile.match(inf)) {
      log(inputFile)
      const ansFile = inputFile.replace(inf, ans)
      if (dict[ansFile] !== undefined) {
        pairs.push({
          inf: inputFile,
          ans: ansFile
        })
      }
    }
  }

  return { pairs }
}

const files = ['1.in', '1.ans', '2.in', '2.ans']

log('files = ', files)

const rule = {
  inf: /(\w+).in/,
  ans: '$1.ans'
}

log('pairs = ', pairFiles(files, rule))
