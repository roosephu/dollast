require! {
  'async'
  'util'
  'child_process': child-process
  './config'
  'fs'
  'tmp'
}

lang-suffix =
  'C': 'c'
  'C++': 'cpp'
  'Java': 'java'

format = (fmt, src, dst) ->
  ...

compile = (lang, code, cb) ->*
  path = yield tmp.file postfix: lang-suffix[lang]
  console.log "#{path}"
  src-file = fs.create-write-stream path
  yield src-file.write code
  exe-path = ...
  compile-cmd = format config.compile-fmt[lang] path exe-path
  output = yield child-process.exec config.compile-cmd
  err = find-err output
  cb err exe-path

run = (lang, code, data-atom, exe) ->*
  exe-file yield compile lang code
  child = child-process.spawn './sandbox'
  child.on 'data', (chunk) ->
    console.log "on data #{chunk}"
  child.on 'exit', (ret-code, signal) ->
    console.log "on exit: #{ret-code} #{signal}"
    cb do
      time: Math.random! * 2
      space: Math.random! * 128
      result: Math.random!
  child.stdin.write "#{lang} #{util.inspect data-atom} #{exe}"

export judge = (lang, code, prob-config) ->*
  tasks = prob-config.dataset
    |> map ->
      (cb) ->
        run lang, code, it, cb
  return new Promise (resolve, reject) ->*
    result = yield async.parallel-limit tasks, config.concurrency
