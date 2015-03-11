app = angular.module 'dollast-sol-app', ["dollast-crud", "dollast-filters"]

app.controller 'sol-submit-ctrl', [
  "$scope", "sol-serv", "$routeParams", "$location"
  ($scope, sol-serv, $route-params, $location) ->
    $scope.sol =
      _id: 'submit'
      pid: parse-int $route-params.pid
      lang: 'C++'
      code: ''
    $scope.submit = ->
      sol-serv.submit $scope.sol
      # $location.path "/solution"
]

app.controller 'sol-list-ctrl', [
  "$scope", "sol-serv", "$routeParams"
  ($scope, sol-serv, $route-params) ->
    $scope.sols = sol-serv.query!
]

app.controller 'sol-show-ctrl', [
  "$scope", "sol-serv", "$routeParams", "$timeout"
  ($scope, sol-serv, $route-params, $timeout) ->
    sid = parse-int $route-params.sid
    $scope.sol = sol-serv.get sid: sid
    $timeout ->
      $ '.ui.checkbox' .checkbox!

    $scope.toggle = ->
      sol-serv.toggle sid: sid, {}, ->
        $scope.sol.open = it.open
]
