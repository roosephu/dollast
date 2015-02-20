app = angular.module 'dollast-app', ["ngRoute"]

app.config ['$routeProvider', ($route-provider) ->
  $route-provider
    .when '/',
      template-url: 'partials/index.html'
      controller  : 'index-ctrl'
    .when '/problem',
      template-url: 'partials/problem/list.html'
      controller  : 'prob-list-ctrl'
    .when '/problem/:pid',
      template-url: 'partials/problem/show.html'
      controller  : 'prob-show-ctrl'
    .when '/solution/submit/:pid',
      template-url: 'partials/solution/submit.html'
      controller  : 'sol-submit-ctrl'
    .when '/problem/modify/:pid',
      template-url: 'partials/problem/modify.html'
      controller  : 'prob-modify-ctrl'
    .when '/login',
      template-url: 'partials/login.html'
      controller  : 'login-ctrl'
    .when '/solution',
      template-url: 'partials/solution/list.html'
      controller  : 'sol-list-ctrl'
    .when '/solution/:sid',
      template-url: 'partials/solution/show.html'
      controller  : 'sol-show-ctrl'
    .otherwise template-url: 'partials/404.html'
]

app.controller 'navbar-ctrl', [
  "$scope", "$http",
  ($scope, $http) ->
    $http.get '/session'
      .success (data, status, headers, config) ->
        $scope.uid = data.user
        console.log "#{JSON.stringify data}"
]

app.controller 'index-ctrl', [
  "$scope", "$http",
  ($scope, $http) ->
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
    $scope.pid = $route-params.pid
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
    pid = $route-params.pid
    $http.get "/problem/#{pid}"
      .success (data, status, headers, config) ->
        $scope.prob = data with _id: pid
    $scope.submit = ->
      $http.post "/problem/modify/#{pid}", $scope.prob
]

app.controller 'sol-submit-ctrl', [
  "$scope", "$http", "$routeParams"
  ($scope, $http, $route-params) ->
    $scope.pid = $route-params.pid
    $scope.lang = 'C++'
    $scope.submit = ->
      $http.post '/solution/submit',
        code: $scope.code
        pid: $scope.pid
        lang: $scope.lang
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
    $scope.sid = $route-params.sid
    $http.get "/solution/#{$scope.sid}"
      .success (data, status, headers, config) ->
        console.log "data: #{data}"
        $scope.sol = data
]
