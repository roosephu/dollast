app = angular.module 'dollast-sol-app', ["dollast-crud", "dollast-filters"]

app.controller 'sol-submit-ctrl', [
  "$scope", "sol-serv", "$routeParams", "$location", "$timeout"
  ($scope, sol-serv, $route-params, $location, $timeout) ->
    $scope.languages = ["cpp", "java"]
    $scope.sol =
      _id: 'submit'
      pid: parse-int $route-params.pid
      lang: 'cpp'
      code: ''
    $timeout ->
      $ '.ui.dropdown' .dropdown!

    $scope.select = (lang) ->
      $scope.sol.lang = lang

    $scope.submit = ->
      sol-serv.submit $scope.sol
      $location.path "/solution"
]

app.controller 'sol-list-ctrl', [
  "$scope", "sol-serv", "$routeParams"
  ($scope, sol-serv, $route-params) ->
    opts =
      uid: $route-params.uid

    $scope.refresh = ->
      $scope.sols = sol-serv.query opts

    $scope.sols = []
    $scope.refresh!

]

app.controller 'sol-show-ctrl', [
  "$scope", "sol-serv", "$routeParams", "$timeout"
  ($scope, sol-serv, $route-params, $timeout) ->
    sid = parse-int $route-params.sid
    $scope.sol = sol-serv.get sid: sid, ->
      $timeout ->
        $ 'pre code' .each (i, block) ->
          hljs.highlight-block block
    $timeout ->
      $ '.ui.checkbox' .checkbox!

    $scope.toggle = ->
      sol-serv.toggle sid: sid, {}, ->
        $scope.sol.open = it.open
]
