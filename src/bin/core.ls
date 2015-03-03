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
  './config'
}
tmp = bluebird.promisify-all tmp

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

flattern-dir = (base-dir) ->*
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
  [zjp-file, clean-up] = yield tmp.file postfix: ext-name
  try
    part.pipe fs.create-write-stream zip-file
    data-dir = path.join config.data-dir "/#pid/"
    child-process.exec "7z x #{zip-file} -o#{data-dir}"
    yield flattern-dir data-dir
  catch err
    throw err
  finally
    clean-up!

export get-data-list = co.wrap (pid) ->
  data-dir = path.join config.data-dir "/#pid/"
  files = fs.readdir-sync data-dir
  return files

judge-result = co.wrap (pid, in-file, out-file, ans-file, config) ->*
  judger = switch config.judger
    | 'string'  => path.join config.judger-dir, "/string"
    | 'real'    => path.join config.judger-dir, "/real"
    | 'strict'  => path.join config.judger-dir, "/strict"
    | 'custom'  => path.join config.data-dir, "/#pid/", "/judge"
    | otherwise => ...
  result = yield child-process.exec "#{judger} #{in-file} #{out-file} #{ans-file}"
  return JSON.parse result

export run-atom = co.wrap (pid, lang, exe-path, config, callback) ->*
  [out-file, callback] = yield tmp.file
  proc = yield child-process.exec "#{config.sandboxer} #{exe-path}
  #{config.time-lmt} #{config.space-lmt} #{config.stk-lmt} #{config.out-lmt} #{config.input} #{out-file}"
  exe-res = JSON.parse proc
  return exe-res if exe-res.status != 'OK'
  judge-res = yield judge-result pid, config.input, out-file, config.output
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
    ...
  catch err
    throw err
  finally
    clean-up!
