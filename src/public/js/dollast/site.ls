app = angular.module 'dollast-site-app', ["dollast-crud", "angular-jwt"]

app.controller 'navbar-ctrl', [
  "$scope", "jwtHelper",
  ($scope, jwt-helper) ->
    $scope.load-token = ->
      token = local-storage.token
      return if not token
      try
        payload = jwt-helper.decode-token token
        console.log payload
        $scope.uid = payload._id
      catch e
        console.log e

    $scope.logout = ->
      delete local-storage.token
      delete $scope.uid
    $scope.load-token!
]

app.controller 'index-ctrl', [
  "$scope", "site-serv", "$location"
  ($scope, site-serv, $location) ->
]

app.controller 'login-ctrl', [
  "$scope", "site-serv"
  ($scope, site-serv) ->
    $scope.submit = (user) ->
      site-serv.login $scope.user, ->
        console.log it
        $scope.msg = it.status != "OK"
        site-serv.token = it.token
        local-storage.token = it.token
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
