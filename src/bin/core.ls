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
  'prelude-ls': _
  './config'
}

log = debug 'core'

export compile = co.wrap (tmp-dir, lang, code) ->*
  src-path = path.join tmp-dir "/main#{config.lang-suffix[lang]}"
  exe-path = path.join tmp-dir "/main"
  src-file = fs.create-write-stream src-path
  src-file.write code

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

judge-result = co.wrap (pid, in-file, out-file, ans-file, config) ->*
  judger = switch config.judger
    | 'string'  => path.join config.judger-dir, "/string"
    | 'real'    => path.join config.judger-dir, "/real"
    | 'strict'  => path.join config.judger-dir, "/strict"
    | 'custom'  => path.join config.data-dir, "/#pid/", "/judge"
    | otherwise => ...
  result = yield child-process.exec "#{judger} #{in-file} #{out-file} #{ans-file}"
  return JSON.parse result

export run-atom = co.wrap (pid, lang, exe-path, config, callback) ->* # TODO if file not exists, throw an error
  [ouf, callback] = yield tmp.file
  inf = path.join config.data-dir, "/#pid/", config.input
  ans = path.join config.data-dir, "/#pid/", config.output
  proc = yield child-process.exec "#{config.sandboxer} #{exe-path}
  #{config.time-lmt} #{config.space-lmt} #{config.stk-lmt} #{config.out-lmt} #{inf} #{ouf}"
  exe-res = JSON.parse proc
  return exe-res if exe-res.status != 'OK'
  judge-res = yield judge-result pid, inf, ouf, ans
  return exe-res <<< judge-res

export judge = co.wrap (lang, code, prob-config, doc) ->*
  [tmp-dir, clean-up] = yield tmp.dir
  try
    exe-path = yield compile tmp-dir, lang, code
    dataset = delete prob-config.dataset
    tasks = dataset
      |> map ->
        (callback) ->
          run-atom pid, lang, exe-path, it with prob-config, callback
    results = yield async.parallel-limit tasks, config.concurrency
    console.log "judge results #{results}"
    # modify doc
    # ...
  catch err
    throw err
  finally
    clean-up!
