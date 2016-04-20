require! {
  \vue-router
}

router = new vue-router!

router.map do
  "/"                             : component: require(\./components/site/index)
  "/about"                        : component: require(\./components/site/about)
  "/problem"                      : component: require(\./components/problem/list)
  "/problem/create"               : component: require(\./components/site/index)
  "/problem/:pid"                 : component: require(\./components/problem/show)
  "/problem/:pid/modify"          : component: require(\./components/site/index)
  "/problem/:pid/stat"            : component: require(\./components/problem/stat)
  "/solution"                     : component: require(\./components/solution/list)
  "/solution/submit/:pid"         : component: require(\./components/site/index)
  "/solution/user/:uid"           : component: require(\./components/site/index)
  "/solution/:sid"                : component: require(\./components/site/index)
  "/round"                        : component: require(\./components/site/index)
  "/round/create"                 : component: require(\./components/site/index)
  "/round/:rid"                   : component: require(\./components/site/index)
  "/round/:rid/modify"            : component: require(\./components/site/index)
  "/round/:rid/board"             : component: require(\./components/site/index)
  "/user"                         : component: require(\./components/site/index)
  "/user/login"                   : component: require(\./components/user/login)
  "/user/register"                : component: require(\./components/site/index)
  "/user/:uid"                    : component: require(\./components/site/index)
  "/user/:uid/modify"             : component: require(\./components/site/index)

module.exports = router
