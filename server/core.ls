require! {
  \async
  \util
  \fs-extra
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

fs = promisify-all fs-extra

log = debug \dollast:core

export compile = (tmp-dir, lang, code) ->*
  src-path = path.join tmp-dir, "/main#{options.lang-suffix[lang]}"
  exe-path = path.join tmp-dir, "/main"
  yield fs.write-file-async src-path, code

  compile-cmd = options.compile-fmt[lang] src-path, exe-path
  log "compile-cmd #{compile-cmd}"
  yield exec compile-cmd
  return exe-path

pair-files = (files) ->

  ext-type = {}
  for suf in [\ans, \out]
    ext-type['.' + suf] = \output
  for suf in [\in, \inp, \inf]
    ext-type['.' + suf] = \input

  buckets = {}
  excessive = []

  for file in files # ensure no directories
    ext = path.extname file
    base = path.basename file, ext
    if ext-type[ext] != void
      buckets.{}[base].[ext-type[ext]] = file
    else
      excessive.push file
  
  pairs = []
  for base, exts of buckets
    if exts.input != void and exts.output != void
      pairs.push exts
    else
      for key, value of exts
        excessive.push key
  return {pairs, excessive}

export upload = (pid, part) ->*
  data-dir = path.join config.data-dir, "/#pid"
  yield fs.mkdirs-async data-dir

  ext-name = path.extname part.filename
  zip-file = tmp.file-sync postfix: ext-name
  tmp-dir = tmp.dir-sync! 

  log "upload #{part.filename} -> #{zip-file.name}"
  try
    yield stream-to-promise part.pipe fs.create-write-stream zip-file.name

    [stdout, stderr] = yield exec "7z e #{zip-file.name} -o#{tmp-dir.name} -y"
    #log "output: #{stdout} #{stderr}"
  catch e
    @assert-name \DecompressError, false, e.message
  finally
    zip-file.remove-callback!
    ret = status: "OK"

  walk = (dir) ->*
    files = yield fs.readdir-async dir

    file-list = []
    for file in files
      whole-path = path.join dir, file
      if fs.stat-sync whole-path .is-directory!
        yield walk whole-path
      else
        file-list.push file
    {pairs, excessive} = pair-files file-list
    for pair in pairs
      {input, output} = pair
      move = (file) ->*
        old = path.join dir, file
        now = path.join data-dir, file
        yield fs.move-async old, now, clobber: true

      yield move input 
      yield move output 
  
  yield walk tmp-dir.name

  log "unzip status: #{util.inspect ret}"
  return ret

export delete-test-data = (pid, filename) ->*
  filename = path.basename filename
  file-path = path.join config.data-dir, "/#pid/", filename
  log "delete #{file-path}"
  yield fs.unlink-async file-path

export upload-image = (part) ->* # deprecated
  ext-name = path.extname part.filename
  {name: image-file} = tmp.file-sync postfix: ext-name, prefix: "", dir: config.image-dir, keep: true
  log "image upload #{part.filename} -> #{path.resolve image-file}"
  part.pipe fs.create-write-stream path.resolve image-file
  base-name = path.basename image-file
  log image-file, base-name
  return "/image/#{base-name}"

export gen-data-pairs = (pid) ->* # what if no directory
  data-dir = path.join config.data-dir, "/#pid/"
  files = yield fs.readdir-async data-dir
  {pairs, excessive} = pair-files files
  return pairs

testlib-exitcodes =
  0: 'ok'
  1: 'wa'
  2: 'pe'
  3: 'fail'
  6: 'unexpected'

drop-first-line = (message) ->
  unlines drop 1, lines message

judge-result = (pid, input-file, output-file, answer-file, cfg) ->*
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

export judge = (language, code, problem-config, doc) ->*
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
