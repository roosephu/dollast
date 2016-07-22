require! {
  \vue-router
}

router = new vue-router!

router.map do
  "/"                             : component: require(\./components/site/index)
  "/about"                        : component: require(\./components/site/about)
  # "/problem"                      : component: require(\./components/problem/list)
  "/problem/create"               : component: require(\./components/problem/modify)
  "/problem/:problem"                 : component: require(\./components/problem/show)
  "/problem/:problem/modify"          : component: require(\./components/problem/modify)
  "/problem/:problem/stat"            : component: require(\./components/problem/stat)
  "/problem/:problem/data"            : component: require(\./components/problem/data)
  "/submission"                   : component: require(\./components/submission/list), name: \submissions
  # "/submission/submit/:problem"       : component: require(\./components/submission/submit)
  "/submission/user/:user"         : component: require(\./components/site/index)
  "/submission/:sid"              : component: require(\./components/submission/show)
  "/pack"                         : component: require(\./components/pack/list)
  "/pack/create"                  : component: require(\./components/pack/modify)
  "/pack/:pack"                    : component: require(\./components/pack/show)
  "/pack/:pack/modify"             : component: require(\./components/pack/modify)
  "/pack/:pack/board"              : component: require(\./components/pack/board)
  "/user"                         : component: require(\./components/user/profile)
  "/user/login"                   : component: require(\./components/user/login)
  "/user/register"                : component: require(\./components/user/register)
  "/user/:user"                    : component: require(\./components/user/profile)
  "/user/:user/modify"             : component: require(\./components/user/modify)

module.exports = router
