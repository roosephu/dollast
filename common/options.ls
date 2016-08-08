module.exports =
  lang-suffix:
    \c : \.c
    \cpp : \.cpp
    \java : \.java
  compile-fmt:
    \cpp : (src, dst) -> "g++ #{src} -o #{dst} -DONLINE_JUDGE"
  sol-list-opts:
    page: 1
    limit: 5
  prob-list-opts:
    page: 1
    limit: 2
  user:
    _id:
      $min: 3
      $max: 15
    password:
      $min: 8
      $max: 16
  problem:
    title:
      $min: 2
      $max: 60
  permit:
    group:
      $min: 2
      $max: 20
  languages: [\cpp, \java]