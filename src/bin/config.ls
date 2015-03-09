require! {
  'path'
}

export
  mode: "debug"
  concurrency: 3
  sandboxer: path.resolve './utils/sandboxer/sandboxer'
  keys: ['drdrd']
  data-dir: path.resolve "./data"
  judger-dir: path.resolve "./utils/judgers"
  image-dir: 'public/image'
  lang-suffix:
    'C': '.c'
    'C++': '.cpp'
    'Java': '.java'
  compile-fmt:
    'C++': (src, dst) -> "g++ #src -o #dst"
  default:
    theme: "dollast"
    priv: {}
  bcrypt-cost: 10
  secret: 'drdrdrd'
  sol-list-opts:
    skip: 0
    limit: 5
  prob-list-opts:
    skip: 0
    limit: 2
