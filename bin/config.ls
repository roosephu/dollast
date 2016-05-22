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
    theme: "vue"
    priv: {}
  bcrypt-cost: 10
  jwt-key: 'drdrdrd'
  server-AES-key: 'da63af5c90e00d60aa3ddd0793a6e3ca6a8284b0fa8884bba72602ec3719c661' # len = 64 bytes
  sol-list-opts:
    skip: 0
    limit: 10
  prob-list-opts:
    skip: 0
    limit: 2
  uid-min-len: 3
  uid-max-len: 15
