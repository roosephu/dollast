require! {
  'async'
  'util'
  'mz/fs'
  'mz/child_process': child-process
  'tmp'
  'bluebird'
  'co'
  'debug'
  'path'
  'co-limiter'
  'prelude-ls': _
  './config'
}

log = debug 'core'
asyc = bluebird.promisify-all async

export compile = co.wrap (tmp-dir, lang, code) ->*
  src-path = path.join tmp-dir, "/main#{config.lang-suffix[lang]}"
  exe-path = path.join tmp-dir, "/main"
  src-file = fs.create-write-stream src-path
  yield fs.write-file src-path, code

  compile-cmd = config.compile-fmt[lang] src-path, exe-path
  log "compile-cmd #{compile-cmd}"
  yield child-process.exec compile-cmd
  return exe-path

flatten-dir = (base-dir) ->*
  walk = (dir) ->*
    files = fs.readdir-sync dir
    for file in files
      if fs.stat-sync file .is-directory!
        walk path.join dir, file
        fs.rmdir dir
      else if dir != base-dir
        fs.rename-sync
  walk base-dir

export upload = co.wrap (pid, part) ->*
  ext-name = path.extname part.filename
  zip-file = tmp.file-sync postfix: ext-name
  log "upload #{part.filename} -> #{zip-file.name}"
  try
    part.pipe fs.create-write-stream zip-file.name
    data-dir = path.join config.data-dir, "/#pid"
    [stdout, stderr] = yield child-process.exec "7z e #{zip-file.name} -o#{data-dir} -y"
    log "output: #{stdout} #{stderr}"
    flatten-dir data-dir # no need to flatten
  catch err
    ret = status: "decompressing error"
  finally
    zip-file.remove-callback!
    ret = status: "OK"
  log "unzip status: #{util.inspect ret}"
  return ret

export gen-data-pairs = co.wrap (pid) ->* # what if no directory
  data-dir = path.join config.data-dir, "/#pid/"
  files = fs.readdir-sync data-dir
  log "files: #{files}"
  pairs = []
  for inf in files # ensure no directories
    inf-path = path.join data-dir, inf
    if ".in" == path.extname inf
      ouf = _.take (inf.length - 2), inf
      ouf = ouf + "out"
      if yield fs.exists path.join data-dir, ouf
        log "find a pair: #{inf} => #{ouf}"
        pairs.push do
          input: inf
          output: ouf
  return pairs

testlib-exitcodes =
  0: 'ok'
  1: 'wa'
  2: 'pe'
  3: 'fail'
  6: 'unexpected'

judge-result = co.wrap (pid, in-file, out-file, ans-file, cfg) ->*
  judger = switch cfg.judger
    | 'string'  => path.join config.judger-dir, "/string"
    | 'real'    => path.join config.judger-dir, "/real"
    | 'strict'  => path.join config.judger-dir, "/strict"
    | 'custom'  => path.join config.data-dir, "/#pid/", "/judge"
    | otherwise => ...
  try
    [stdout, stderr] = yield child-process.exec "#{judger} #{in-file} #{out-file} #{ans-file}"
  catch e
    messages = _.unlines _.drop 1, _.lines e.message
    return
      status: testlib-exitcodes[e.code]
      score: 0
      message: messages.trim!
  [status, score, ...message] = stderr.trim!.split ' '
  log "judger output: #stdout / #status / #score / #message"
  message = _.unwords message
  return
    status: status
    score: parse-float score
    message: message

limit = co-limiter config.concurrency

run-atom = (pid, lang, exe-path, data, cfg) ->* # TODO if file not exists, throw an error
  log "running atom..."
  tmp-file = tmp.file-sync!
  ouf = tmp-file.name
  inf = path.join config.data-dir, "/#pid/", data.input
  ans = path.join config.data-dir, "/#pid/", data.output
  log "inf #{inf} ans #{ans}"
  exec-cmd = "\"#{config.sandboxer}\" \"#{exe-path}\" #{cfg.time-lmt} #{cfg.space-lmt} #{cfg.stk-lmt} #{cfg.out-lmt} \"#{inf}\" \"#{ouf}\""
  [proc-out, proc-err] = yield child-process.exec exec-cmd, cwd: path.dirname config.sandboxer
  log "sandboxer result: #proc-err"
  exe-res = JSON.parse proc-err

  if exe-res.status != 'OK'
    tmp-file.remove-callback!
    return exe-res <<< input: data.input

  judge-res = yield judge-result pid, inf, ouf, ans, cfg
  tmp-file.remove-callback!
  return exe-res <<< judge-res <<< input: data.input

calc-prob-score = (results) ->
  ret =
    max-time : 0
    max-space: 0

  [sum, ws] = [0, 0]
  for [data, result] in results
    if result.time
      ret.max-time  >?= result.time
    if result.space
      ret.max-space >?= result.space
    sum += data.weight * result.score
    ws  += data.weight
  return ret <<< score: sum / ws

export judge = co.wrap (lang, code, prob-config, doc) ->*
  log "Start judging: lang: #{lang}"
  tmp-dir = tmp.dir-sync unsafe-cleanup: true
  config = prob-config.to-object!
  pid = doc.prob._id
  try
    exe-path = yield compile tmp-dir.name, lang, code
    dataset = delete config.dataset

    results = []
    for data in dataset
      res = yield limit run-atom pid, lang, exe-path, data, config
      results.push res

    log "starting modifying doc"
    doc.results = results
    doc <<< calc-prob-score _.zip dataset, results
    yield doc.save!
  catch err
    log err
    ret = err
  finally
    tmp-dir.remove-callback!
    ret = status: "OK"
  return ret
