_ = require 'prelude-ls'

app = angular.module "dollast-user-app", ["dollast-crud", "dollast-sess"]

app.controller "user-modify-ctrl", [
  "$scope", "user-serv", "$routeParams", "user-session"
  ($scope, user-serv, $route-params, user-session) ->
    $scope.user = user-serv.get uid: $route-params.uid
    $scope.priv = ""

    $scope.submit = ->
      user-serv.save $scope.user
    $scope.insert = ->
      $scope.user.priv-list.push $scope.priv
    $scope.remove = (priv) ->
      $scope.user.priv-list = _.reject (== priv), $scope.user.priv-list
    $scope.delete = ->
      ...
]

app.controller "user-reg-ctrl", [
  "$scope", "user-session"
  ($scope, user-session) ->
    $scope.submit = ->
      user-session.register $scope.uid, $scope.pswd
]

app.controller 'user-profile-ctrl', [
  "$scope", "user-serv", "$routeParams"
  ($scope, user-serv, $route-params) ->
    $scope.user = user-serv.get uid: $route-params.uid
]
