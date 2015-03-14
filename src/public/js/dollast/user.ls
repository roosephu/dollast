_ = require 'prelude-ls'

app = angular.module "dollast-user-app", ["dollast-crud"]

app.controller "user-modify-ctrl", [
  "$scope", "user-serv", "$routeParams"
  ($scope, user-serv, $route-params) ->
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
  "$scope", "user-serv",
  ($scope, user-serv) ->
    user-serv.usr = {}
    $scope.submit = ->
      user-serv.reg $scope.usr
]

app.controller 'user-profile-ctrl', [
  "$scope", "user-serv", "$routeParams"
  ($scope, user-serv, $route-params) ->
    $scope.user = user-serv.get uid: $route-params.uid
]
