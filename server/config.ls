require! {
  \path
  \../common/judgers
}

export
  pass-guest: false
  mode: \debug
  concurrency: 3
  sandboxer: path.resolve \./utils/sandboxer/sandboxer
  keys: [\drdrd]
  data-dir: path.resolve \./data
  judger-dir: path.resolve \./utils/judgers
  judgers: judgers
  image-dir: \public/image
  lang-suffix:
    \c : \.c
    \cpp : \.cpp
    \java : \.java
  compile-fmt:
    \cpp : (src, dst) -> "g++ #{src} -o #{dst}"
  default:
    theme: \vue
    groups: {}
  bcrypt-cost: 10
  jwt-key: \drdrdrd
  server-AES-key: \da63af5c90e00d60aa3ddd0793a6e3ca6a8284b0fa8884bba72602ec3719c661 # len = 64 bytes
  sol-list-opts:
    page: 1
    limit: 5
  prob-list-opts:
    page: 1
    limit: 2
  uid-min-len: 3
  uid-max-len: 15
  starting-ids:
    submissions: 1
    problems: 1
    rounds: 1
