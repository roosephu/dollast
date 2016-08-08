require! {
  \async
  \util
  \mz/fs
  \mz/child_process : {exec}
  \tmp
  \bluebird : {promisify-all}
  \stream-to-promise
  \co
  \debug
  \path
  \co-limiter
  \prelude-ls : {take, unlines, drop, lines, unwords, zip}
  \./config
  \../common/options
}

log = debug \dollast:core

export compile = co.wrap (tmp-dir, lang, code) ->*
  src-path = path.join tmp-dir, "/main#{options.lang-suffix[lang]}"
  exe-path = path.join tmp-dir, "/main"
  src-file = fs.create-write-stream src-path
  yield fs.write-file src-path, code

  compile-cmd = options.compile-fmt[lang] src-path, exe-path
  log "compile-cmd #{compile-cmd}"
  yield exec compile-cmd
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
    yield stream-to-promise part.pipe fs.create-write-stream zip-file.name
    data-dir = path.join config.data-dir, "/#pid"
    [stdout, stderr] = yield exec "7z e #{zip-file.name} -o#{data-dir} -y"
    #log "output: #{stdout} #{stderr}"
    flatten-dir data-dir # no need to flatten
  catch err
    ret = status: "decompressing error"
    log err
  finally
    zip-file.remove-callback!
    ret = status: "OK"
  log "unzip status: #{util.inspect ret}"
  return ret

export delete-test-data = co.wrap (pid, filename) ->*
  filename = path.basename filename
  file-path = path.join config.data-dir, "/#pid/", filename
  log "delete #{file-path}"
  yield fs.unlink file-path

export upload-image = co.wrap (part) ->* # deprecated
  ext-name = path.extname part.filename
  {name: image-file} = tmp.file-sync postfix: ext-name, prefix: "", dir: config.image-dir, keep: true
  log "image upload #{part.filename} -> #{path.resolve image-file}"
  part.pipe fs.create-write-stream path.resolve image-file
  base-name = path.basename image-file
  log image-file, base-name
  return "/image/#{base-name}"

export gen-data-pairs = co.wrap (pid) ->* # what if no directory
  data-dir = path.join config.data-dir, "/#pid/"
  files = fs.readdir-sync data-dir
  log "files: #{files}"
  acceptable-suffixes = [\ans, \out]
  pairs = []
  for inf in files # ensure no directories
    inf-path = path.join data-dir, inf
    if ".in" == path.extname inf
      pref = take (inf.length - 2), inf
      for suffix in acceptable-suffixes
        ouf = pref + suffix
        if yield fs.exists path.join data-dir, ouf
          log "find a pair: #{inf} => #{ouf}"
          pairs.push do
            input: inf
            output: ouf
          break
  return pairs

testlib-exitcodes =
  0: 'ok'
  1: 'wa'
  2: 'pe'
  3: 'fail'
  6: 'unexpected'

drop-first-line = (message) ->
  unlines drop 1, lines message

judge-result = co.wrap (pid, input-file, output-file, answer-file, cfg) ->*
  judger = switch cfg.judger
    | 'custom'  => path.join config.data-dir, "/#pid/", "/judge"
    | otherwise => path.join config.judger-dir, "/#{cfg.judger}"
  try
    [stdout, stderr] = yield exec "#{judger} #{input-file} #{output-file} #{answer-file}"
  catch e
    # log e
    messages = drop-first-line e.message
    return
      status: testlib-exitcodes[e.code]
      score: 0
      message: messages.trim!
  [status, score, ...message] = stderr.trim!.split ' '

  log {stderr, stdout, status, score, message}
  message = unwords message
  return
    status: status
    score: 1 # parse-float score
    message: message

limit = co-limiter config.concurrency

run-atom = (pid, language, exe-path, data, cfg) ->* # TODO if file not exists, throw an error
  # log "running atom..."
  tmp-file = tmp.file-sync!
  ouf = tmp-file.name
  inf = path.join config.data-dir, "/#pid/", data.input
  ans = path.join config.data-dir, "/#pid/", data.output
  log "inf #{inf} ans #{ans}"
  exec-cmd = "\"#{config.sandboxer}\" \"#{exe-path}\" #{cfg.time-limit} #{cfg.space-limit} #{cfg.stack-limit} #{cfg.output-limit} \"#{inf}\" \"#{ouf}\""
  # log {exec-cmd}
  [proc-out, proc-err] = yield exec exec-cmd, cwd: path.dirname config.sandboxer
  log {proc-out, proc-err, exec-cmd}
  exe-res = JSON.parse proc-err
  log "sandboxer result:", exe-res

  if exe-res.status != 'OK'
    tmp-file.remove-callback!
    return exe-res <<< data

  judge-res = yield judge-result pid, inf, ouf, ans, cfg
  tmp-file.remove-callback!

  return (exe-res <<< judge-res) <<< data

calc-problem-score = (results) ->
  ret =
    time : 0
    space: 0
    score: 0

  [sum, ws] = [0, 0]
  for [data, result] in results
    # log {data, result}
    if result.time
      ret.time  >?= result.time
    if result.space
      ret.space >?= result.space
    sum += data.weight * result.score
    ws  += data.weight
  ret.score = if ws then sum / ws else 0
  return ret

export judge = co.wrap (language, code, problem-config, doc) ->*
  log "Start judging: language: #{language}"
  tmp-dir = tmp.dir-sync unsafe-cleanup: true
  config = problem-config.to-object!
  pid = doc.problem
  try
    exe-path = yield compile tmp-dir.name, language, code
  catch err
    message = drop-first-line err.message
    tmp-dir.remove-callback!
    log err
    log "CE:", message
    doc.summary =
      score: 0
      status: "CE"
      message: message
    yield doc.save!
    return status: "CE"

  try
    dataset = delete config.dataset

    results = yield [limit run-atom pid, language, exe-path, data.to-object!, config for data in dataset]

    log "writing back"
    doc.results = results
    doc.summary = calc-problem-score zip dataset, results
    doc.summary.status = \finished
    log doc
    yield doc.save!
  catch err
    log err
  finally
    tmp-dir.remove-callback!
    ret = status: "OK"
  return ret
