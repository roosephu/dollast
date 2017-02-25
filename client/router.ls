require! {
  \vue
  \vue-router
}

vue.use vue-router
router = new vue-router routes:
  * path: "/"                             , component: require(\./components/site/index)
  * path: "/about"                        , component: require(\./components/site/about)
  # "/problem"                      : component: require(\./components/problem/list)
  * path: "/problem/create"               , component: require(\./components/problem/modify)
  * path: "/problem/:problem"             , component: require(\./components/problem/show)
  * path: "/problem/:problem/modify"      , component: require(\./components/problem/modify)
  * path: "/problem/:problem/stat"        , component: require(\./components/problem/stat)
  * path: "/problem/:problem/data"        , component: require(\./components/problem/data)
  * path: "/submission"                   , component: require(\./components/submission/list), name: \submissions
  # # "/submission/submit/:problem"       : component: require(\./components/submission/submit)
  * path: "/submission/user/:user"        , component: require(\./components/site/index)
  * path: "/submission/:sid"              , component: require(\./components/submission/show)
  * path: "/pack"                         , component: require(\./components/pack/list)
  * path: "/pack/create"                  , component: require(\./components/pack/modify)
  * path: "/pack/:pack"                   , component: require(\./components/pack/show)
  * path: "/pack/:pack/modify"            , component: require(\./components/pack/modify)
  * path: "/pack/:pack/board"             , component: require(\./components/pack/board)
  * path: "/user"                         , component: require(\./components/user/profile)
  * path: "/user/login"                   , component: require(\./components/user/login)
  * path: "/user/register"                , component: require(\./components/user/register)
  * path: "/user/:user"                   , component: require(\./components/user/profile)
  * path: "/user/:user/modify"            , component: require(\./components/user/modify)
  * path: '/problem'                      , redirect: '/pack/0'
  * path: '*'                             , redirect: '/'

# router.redirect do
#   '/problem' : '/pack/0'
#   '*'        : '/'

module.exports = router
