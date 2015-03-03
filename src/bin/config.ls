export
  concurrency: 3
  sandboxer: './sandboxer/sandboxer'
  keys: ['drdrd']
  data-dir: "./data"
  judger-dir: "./utils/judgers"
  lang-suffix:
    'C': '.c'
    'C++': '.cpp'
    'Java': '.java'
  compile-fmt:
    'C++': (src, dst) -> "g++ #src -o #dst"
