require! {
  'path'
}

export
  pass-guest: false
  mode: "debug"
  concurrency: 3
  sandboxer: path.resolve './utils/sandboxer/sandboxer'
  keys: ['drdrd']
  data-dir: path.resolve "./data"
  judger-dir: path.resolve "./utils/judgers"
  image-dir: 'public/image'
  lang-suffix:
    'c': '.c'
    'cpp': '.cpp'
    'java': '.java'
  compile-fmt:
    'cpp': (src, dst) -> "g++ #src -o #dst"
  default:
    theme: "dollast"
    priv: {}
  bcrypt-cost: 10
  secret: 'drdrdrd'
  sol-list-opts:
    skip: 0
    limit: 10
  prob-list-opts:
    skip: 0
    limit: 2
  uid-min-len: 3
  uid-max-len: 15
