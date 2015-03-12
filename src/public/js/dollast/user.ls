_ = require 'prelude-ls'

app = angular.module "dollast-user-app", ["dollast-crud"]

app.controller "user-modify-ctrl", [
  "$scope", "user-serv", "$routeParams"
  ($scope, user-serv, $route-params) ->
    $scope.usr = user-serv.get uid: $route-params.uid
    $scope.priv = ""

    $scope.submit = ->
      user-serv.save $scope.usr
    $scope.insert = ->
      $scope.usr.priv-list.push $scope.priv
    $scope.remove = (priv) ->
      $scope.usr.priv-list = _.reject (== priv), $scope.usr.priv-list
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
