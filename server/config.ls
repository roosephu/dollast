require! {
  \path
  \../common
}

export
  pass-guest: false
  mode: \debug
  concurrency: 3
  sandboxer: path.resolve \./utils/sandboxer/sandboxer
  keys: [\drdrd]
  data-dir: path.resolve \./data
  judger-dir: path.resolve \./utils/judgers
  judgers: common.judgers
  image-dir: \public/image
  default:
    theme: \vue
    groups: {}
  bcrypt-cost: 10
  jwt-key: \drdrdrd
  server-AES-key: \da63af5c90e00d60aa3ddd0793a6e3ca6a8284b0fa8884bba72602ec3719c661 # len = 64 bytes
  starting-ids:
    submissions: 1
    problems: 1
    packs: 1
