require! {
  \vue : {default: vue}
  \vue-router : {default: vue-router}
  \debug
}

log = debug \dollast:client:router

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
  * path: "/round"                        , component: require(\./components/round/list)
  * path: "/round/create"                 , component: require(\./components/round/modify)
  * path: "/round/:round"                 , component: require(\./components/round/show)
  * path: "/round/:round/modify"          , component: require(\./components/round/modify)
  * path: "/round/:round/board"           , component: require(\./components/round/board)
  * path: "/user"                         , component: require(\./components/user/profile)
  * path: "/user/login"                   , component: require(\./components/user/login)
  * path: "/user/register"                , component: require(\./components/user/register)
  * path: "/user/:user"                   , component: require(\./components/user/profile)
  * path: "/user/:user/modify"            , component: require(\./components/user/modify)
  * path: '/problem'                      , redirect: '/round/0'
  * path: '*'                             , redirect: '/'

# router.redirect do
#   '/problem' : '/round/0'
#   '*'        : '/'

module.exports = router
