require! {
  \vue-router
}

router = new vue-router!

router.map do
  "/"                             : component: require(\./components/site/index)
  "/about"                        : component: require(\./components/site/about)
  "/problem"                      : component: require(\./components/problem/list)
  "/problem/create"               : component: require(\./components/problem/modify)
  "/problem/:pid"                 : component: require(\./components/problem/show)
  "/problem/:pid/modify"          : component: require(\./components/problem/modify)
  "/problem/:pid/stat"            : component: require(\./components/problem/stat)
  "/problem/:pid/data"            : component: require(\./components/problem/data)
  "/solution"                     : component: require(\./components/solution/list)
  "/solution/submit/:pid"         : component: require(\./components/solution/submit)
  "/solution/user/:uid"           : component: require(\./components/site/index)
  "/solution/:sid"                : component: require(\./components/solution/show)
  "/round"                        : component: require(\./components/round/list)
  "/round/create"                 : component: require(\./components/round/modify)
  "/round/:rid"                   : component: require(\./components/round/show)
  "/round/:rid/modify"            : component: require(\./components/round/modify)
  "/round/:rid/board"             : component: require(\./components/round/board)
  "/user"                         : component: require(\./components/user/profile)
  "/user/login"                   : component: require(\./components/user/login)
  "/user/register"                : component: require(\./components/user/register)
  "/user/:uid"                    : component: require(\./components/user/profile)
  "/user/:uid/modify"             : component: require(\./components/user/modify)

module.exports = router
