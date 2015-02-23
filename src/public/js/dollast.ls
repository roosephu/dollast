_ = require 'prelude-ls'
app = angular.module 'dollast-app', ["ngRoute", "ui.dateTimeInput"]

app.config ['$routeProvider', ($route-provider) ->
  $route-provider
    .when '/',
      template-url: 'partials/index.html'
      controller  : 'index-ctrl'
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

app.service 'doffirst', ['$http',
  class
    (@$http) ->
      @caller = (obj, opts, cb, http) ->
        http.success (data, status, headers, config) ->
          if typeof opts == 'undefined'
            opts = {}
          else if typeof opts == 'function'
            cb = opts
            opts = {}
          obj <<< data
          if opts.debug
            console.log "data: #{JSON.stringify data}"
          cb $scope if cb
    get: (url, obj, opts, cb) ->
      @caller obj, opts, cb, @$http.get url
    put: (url, data, obj, opts, cb) ->
      @caller obj, opts, cb, @$http.put url, data
    post: (url, data, opts, cb) ->
      @caller obj, opts, cb, @$http.post url, data
    delete: (url, opts, cb) ->
      @caller obj, opts, cb, @$http.delete url
]

app.controller 'navbar-ctrl', [
  "$scope", "doffirst",
  ($scope, doffirst) ->
    doffirst.get '/session', $scope
    /*$http.get '/session'
      .success (data, status, headers, config) ->
        $scope.uid = data.uid
        console.log "#{JSON.stringify data}"*/
]

app.controller 'index-ctrl', [
  "$scope", "$http", "$location"
  ($scope, $http, $location) ->
    $scope.submit = ->
      $location.path "/solution"
]

app.controller 'login-ctrl', [
  "$scope", "$http",
  ($scope, $http) ->
    $scope.user =
      username: ''
      password: ''
    $scope.submit = (user) ->
      console.log user
      $http.post '/login', $scope.user
        .success (data, status, headers, config) ->
          console.log 'login OK'
        .error (data, status, headers, config) ->
          console.log 'login Error'
]

app.controller 'prob-show-ctrl', [
  "$scope", "$http", "$routeParams"
  ($scope, $http, $route-params) ->
    $scope.pid = parse-int $route-params.pid
    $http.get "/problem/#{$scope.pid}"
      .success (data, status, headers, config) ->
        console.log data
        $scope.prob = data
]

app.controller 'prob-list-ctrl', [
  "$scope", "$http", "$routeParams"
  ($scope, $http, $route-params) ->
    $http.get "/problem"
      .success (data, status, headers, config) ->
        console.log "data: #{data}"
        $scope.probs = data
]

app.controller 'prob-modify-ctrl', [
  "$scope", "$http", "$routeParams"
  ($scope, $http, $route-params) ->
    if $route-params.pid
      pid = parse-int that
      $http.get "/problem/#{pid}/modify"
        .success (data, status, headers, config) ->
          $scope.prob = data with _id: pid
          console.log data
    else
      $http.get "/problem/create"
        .success (data, status, headers, config) ->
          console.log data
          $scope.prob = data
    $scope.submit = ->
      console.log $scope.prob
      $http.put "/problem/#{pid}", $scope.prob
]

app.controller 'sol-submit-ctrl', [
  "$scope", "$http", "$routeParams", "$location"
  ($scope, $http, $route-params, $location) ->
    $scope.pid = parse-int $route-params.pid
    $scope.lang = 'C++'
    $scope.submit = ->
      $http.post '/submit',
        code: $scope.code
        pid: $scope.pid
        lang: $scope.lang
      $location.path "/solution"
]

app.controller 'sol-list-ctrl', [
  "$scope", "$http", "$routeParams"
  ($scope, $http, $route-params) ->
    $http.get "/solution"
      .success (data, status, headers, config) ->
        console.log "data: #{data}"
        $scope.sols = data
]

app.controller 'sol-show-ctrl', [
  "$scope", "$http", "$routeParams"
  ($scope, $http, $route-params) ->
    $scope.sid = parse-int $route-params.sid
    $http.get "/solution/#{$scope.sid}"
      .success (data, status, headers, config) ->
        console.log "data: #{data}"
        $scope.sol = data
]

app.controller 'rnd-list-ctrl', [
  "$scope", "$http", "$routeParams"
  ($scope, $http, $route-params) ->
    $http.get "/round"
      .success (data, status, headers, config) ->
        console.log data
        $scope.rounds = data
]

app.controller 'rnd-show-ctrl', [
  "$scope", "$http", "$routeParams"
  ($scope, $http, $route-params) ->
    rid = parse-int $route-params.rid
    $http.get "/round/#{rid}"
      .success (data, status, headers, config) ->
        console.log data
        $scope <<< data
]

app.controller 'rnd-modify-ctrl', [
  "$scope", "$http", "$routeParams"
  ($scope, $http, $route-params) ->
    $scope.pid = 0
    if $route-params.rid
      $http.get "/round/#{that}/modify"
        .success (data, status, headers, config) ->
          $scope.rnd = data with _id: that
          $scope.probs = data.probs
          console.log "initial #{$scope.probs}"
    else
      $http.get "/round/create"
        .success (data, status, headers, config) ->
          $scope.rnd = data with
            beg-time: new Date Date.now!
            end-time: new Date Date.now!
          $scope.probs = []
    $scope.submit = ->
      console.log $scope.rnd
      $scope.rnd.probs = _.map (._id), $scope.probs
      console.log typeof $scope.rnd.probs
      $http.put "/round/#{$scope.rnd._id}", $scope.rnd
    $scope.insert = ->
      $http.get "/problem/#{$scope.pid}"
        .success (data, status, headers, config) ->
          $scope.probs.push data
    $scope.remove = (pid) ->
      $scope.probs = _.reject (._id == pid), $scope.probs
    $scope.delete = ->
      $http.delete "/round/#{$scope.rnd._id}"
]
