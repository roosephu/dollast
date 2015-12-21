app = angular.module 'dollast-site-app', ["dollast-crud", "angular-jwt"]

app.controller 'navbar-ctrl', [
  "$scope", "jwtHelper", "user-session"
  ($scope, jwt-helper, user-session) ->
    sess = $scope.sess = user-session
    $scope.load-token = ->
      sess.load-token!
    $scope.logout = ->
      sess.logout!
    $scope.load-token!
]

app.controller 'index-ctrl', [
  "$scope", "site-serv", "$location"
  ($scope, site-serv, $location) ->
]

app.controller 'login-ctrl', [
  "$scope", "site-serv", "user-session"
  ($scope, site-serv, user-session) ->
    $scope.submit = (user) ->
      user-session.login $scope.user._ \i,d, $scope.user.pswd
]

app.controller 'msg-center-ctrl', [
  "$scope", "$timeout", "msgCenter"
  ($scope, $timeout, msg-center) ->
    $scope.shared =
      messages: []
      type: ""

    console.log msg-center
    $timeout ->
      msg-center.load $scope.shared

    $scope.flip = (dir) !->
      msg-center.shape dir
    $scope.style = (type) ->
      switch type
        | "ok"  => "green"
        | "err" => "red"
        | _     => ...
]
