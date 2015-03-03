app = angular.module 'dollast-app', [
  * "ngRoute"
  * "dollast-site-app"
  * "dollast-prob-app"
  * "dollast-sol-app"
  * "dollast-rnd-app"
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
    .when '/submit/:pid',
      template-url: 'partials/solution/submit.html'
      controller  : 'sol-submit-ctrl'
    .when '/login',
      template-url: 'partials/login.html'
      controller  : 'login-ctrl'
    .when '/solution',
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
    .otherwise template-url: 'partials/404.html'
]
