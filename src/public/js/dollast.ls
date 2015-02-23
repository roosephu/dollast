_ = require 'prelude-ls'
app = angular.module 'dollast-app', ["ngRoute", "ui.dateTimeInput"]

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

mk-cb = (a, b, c) ->
  f = (a, y) ->
    a = y
  c.x f a

app.service 'doffirst', ['$http',
  class
    (@$http) ->
      @caller = (obj, opts, cb, http) ->
        suc-cb = (obj, opts, cb, data, status, headers, config) -->
          if 'undefined' == typeof opts
            opts = {}
          else if 'function' == typeof opts
            cb = opts
            opts = {}
          if opts.debug
            console.log "data: #{JSON.stringify data}"
          if obj
            obj <<< data
            cb obj if cb
        http.success suc-cb obj, opts, cb
    get: (url, obj, opts, cb) ->
      @caller obj, opts, cb, @$http.get url
    put: (url, data, obj, opts, cb) ->
      @caller obj, opts, cb, @$http.put url, data
    post: (url, data, obj, opts, cb) ->
      @caller obj, opts, cb, @$http.post url, data
    delete: (url, obj, opts, cb) ->
      @caller obj, opts, cb, @$http.delete url
]

app.controller 'navbar-ctrl', [
  "$scope", "doffirst",
  ($scope, doffirst) ->
    doffirst.get '/session', $scope
]

app.controller 'index-ctrl', [
  "$scope", "doffirst", "$location"
  ($scope, doffirst, $location) ->
    $scope.submit = ->
      $location.path "/solution"
]

app.controller 'login-ctrl', [
  "$scope", "doffirst",
  ($scope, doffirst) ->
    $scope.user =
      username: ''
      password: ''
    $scope.submit = (user) ->
      console.log user
      doffirst.post '/login', $scope.user, $scope, ->
        it.msg = it.status == false
]

app.controller 'prob-show-ctrl', [
  "$scope", "doffirst", "$routeParams"
  ($scope, doffirst, $route-params) ->
    $scope.pid = parse-int $route-params.pid
    doffirst.get "/problem/#{$scope.pid}", $scope
]

app.controller 'prob-list-ctrl', [
  "$scope", "doffirst", "$routeParams"
  ($scope, doffirst, $route-params) ->
    doffirst.get "/problem", $scope
]

app.controller 'prob-modify-ctrl', [
  "$scope", "doffirst", "$routeParams"
  ($scope, doffirst, $route-params) ->
    if $route-params.pid
      pid = parse-int that
      doffirst.get "/problem/#{pid}/modify", $scope, -> it <<< _id: pid
    else
      doffirst.get "/problem/create", $scope
    $scope.submit = ->
      console.log $scope.prob
      doffirst.put "/problem/#{pid}", $scope.prob
]

app.controller 'sol-submit-ctrl', [
  "$scope", "doffirst", "$routeParams", "$location"
  ($scope, doffirst, $route-params, $location) ->
    $scope.pid = parse-int $route-params.pid
    $scope.lang = 'C++'
    $scope.submit = ->
      doffirst.post '/submit',
        code: $scope.code
        pid: $scope.pid
        lang: $scope.lang
        {}
      $location.path "/solution"
]

app.controller 'sol-list-ctrl', [
  "$scope", "doffirst", "$routeParams"
  ($scope, doffirst, $route-params) ->
    doffirst.get "/solution", $scope
]

app.controller 'sol-show-ctrl', [
  "$scope", "doffirst", "$routeParams"
  ($scope, doffirst, $route-params) ->
    $scope.sid = parse-int $route-params.sid
    doffirst.get "/solution/#{$scope.sid}", $scope
]

app.controller 'rnd-list-ctrl', [
  "$scope", "doffirst", "$routeParams"
  ($scope, doffirst, $route-params) ->
    doffirst.get "/round", $scope
]

app.controller 'rnd-show-ctrl', [
  "$scope", "doffirst", "$routeParams"
  ($scope, doffirst, $route-params) ->
    rid = parse-int $route-params.rid
    doffirst.get "/round/#{rid}", $scope
]

app.controller 'rnd-modify-ctrl', [
  "$scope", "doffirst", "$routeParams"
  ($scope, doffirst, $route-params) ->
    $scope.pid = 0
    if $route-params.rid
      doffirst.get "/round/#{that}/modify", $scope, ->
        it.rnd <<< _id: that
        it.probs = it.rnd.probs
    else
      doffirst.get "/round/create", $scope, ->
        it.rnd <<<
          beg-time: new Date Date.now!
          end-time: new Date Date.now!
        it.probs = []
    $scope.submit = ->
      console.log $scope.rnd
      $scope.rnd.probs = _.map (._id), $scope.probs
      doffirst.put "/round/#{$scope.rnd._id}", $scope.rnd
    $scope.insert = ->
      new-prob = {}
      doffirst.get "/problem/#{$scope.pid}", new-prob, ->
        $scope.probs.push it.prob
    $scope.remove = (pid) ->
      $scope.probs = _.reject (._id == pid), $scope.probs
    $scope.delete = ->
      doffirst.delete "/round/#{$scope.rnd._id}"
]
