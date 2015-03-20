app = angular.module 'dollast-app', [
  * "angular-jwt"
  * "ngRoute"
  * "dollast-msg-center"
  * "dollast-filters"
  * "dollast-user-app"
  * "dollast-site-app"
  * "dollast-prob-app"
  * "dollast-sol-app"
  * "dollast-rnd-app"
]

app.config  [
  "$httpProvider", "jwtInterceptorProvider",
  ($http-provider, jwt-interceptor-provider) ->
    jwt-interceptor-provider.token-getter = ->
      local-storage.token

    $http-provider.interceptors.push ["$q", "msgCenter", ($q, msg-center) ->
      response: ->
        if it.data?.status? # JSON returned
          info = that
          if "object" == typeof info
            msg-center.push info
          else if "string" == typeof info
            msg-center.push do
              type: "ok"
              msg: info
          else
            console.log "bad status returned", info
        return it
      response-error: (rejection) ->
        if rejection.status == 400 and "object" == typeof rejection.data
          for part in rejection.data
            for param, msg of part
              msg-center.push do
                type: "err"
                msg: "#param: #msg"
        return $q.reject rejection
    ]

    $http-provider.interceptors.push 'jwtInterceptor'
]

app.config ['$routeProvider', ($route-provider) ->
  $route-provider
    .when '/',
      template-url: 'partials/index.html'
      controller  : 'index-ctrl'
    .when '/about',
      template-url: 'partials/about.html'
    .when '/problem',
      template-url: 'partials/problem/list.html'
      controller  : 'prob-list-ctrl'
    .when '/problem/create',
      template-url: 'partials/problem/modify.html'
      controller  : 'prob-modify-ctrl'
    .when '/problem/:pid',
      template-url: 'partials/problem/show.html'
      controller  : 'prob-show-ctrl'
    .when '/problem/:pid/modify',
      template-url: 'partials/problem/modify.html'
      controller  : 'prob-modify-ctrl'
    .when '/problem/:pid/stat',
      template-url: 'partials/problem/stat.html'
      controller  : 'prob-stat-ctrl'
    .when '/submit/:pid',
      template-url: 'partials/solution/submit.html'
      controller  : 'sol-submit-ctrl'
    .when '/login',
      template-url: 'partials/login.html'
      controller  : 'login-ctrl'
    .when '/solution',
      template-url: 'partials/solution/list.html'
      controller  : 'sol-list-ctrl'
    .when '/solution/user/:uid',
      template-url: 'partials/solution/list.html'
      controller  : 'sol-list-ctrl'
    .when '/solution/:sid',
      template-url: 'partials/solution/show.html'
      controller  : 'sol-show-ctrl'
    .when '/round',
      template-url: 'partials/round/list.html'
      controller  : 'rnd-list-ctrl'
    .when '/round/create',
      template-url: 'partials/round/modify.html'
      controller  : 'rnd-modify-ctrl'
    .when '/round/:rid',
      template-url: 'partials/round/show.html'
      controller  : 'rnd-show-ctrl'
    .when '/round/:rid/modify',
      template-url: 'partials/round/modify.html'
      controller  : 'rnd-modify-ctrl'
    .when '/round/:rid/board',
      template-url: 'partials/round/board.html'
      controller  : 'rnd-board-ctrl'
    .when '/user/register',
      template-url: 'partials/user/register.html'
      controller  : 'user-reg-ctrl'
    .when '/user/:uid',
      template-url: 'partials/user/profile.html'
      controller  : 'user-profile-ctrl'
    .when '/user/:uid/modify',
      template-url: 'partials/user/modify.html'
      controller  : 'user-modify-ctrl'
    .otherwise template-url: 'partials/404.html'
]
