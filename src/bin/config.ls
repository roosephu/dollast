require! {
  'path'
}

export
  concurrency: 3
  sandboxer: path.resolve './utils/sandboxer/sandboxer'
  keys: ['drdrd']
  data-dir: path.resolve "./data"
  judger-dir: path.resolve "./utils/judgers"
  lang-suffix:
    'C': '.c'
    'C++': '.cpp'
    'Java': '.java'
  compile-fmt:
    'C++': (src, dst) -> "g++ #src -o #dst"
  default:
    theme: "default"
    priv:
      "prob-view": true
  bcrypt-cost: 10
