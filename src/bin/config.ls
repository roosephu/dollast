export
  concurrency: 3
  sandboxer: './sandboxer/sandboxer'
  keys: ['drdrd']
  data-dir: "/home/dollast/data"
  judger-dir: "./utils/judger"
  lang-suffix:
    'C': '.c'
    'C++': '.cpp'
    'Java': '.java'
  compile-fmt:
    'C++': (src, dst) -> "g++ #src -o #dst"
