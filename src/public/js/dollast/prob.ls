prob-app = angular.module 'dollast-prob-app', ["doffirst"]

prob-app.controller 'prob-show-ctrl', [
  "$scope", "doffirst", "$routeParams"
  ($scope, doffirst, $route-params) ->
    $scope.pid = parse-int $route-params.pid
    doffirst.get "/problem/#{$scope.pid}", $scope
]

prob-app.controller 'prob-list-ctrl', [
  "$scope", "doffirst", "$routeParams"
  ($scope, doffirst, $route-params) ->
    doffirst.get "/problem", $scope
]

prob-app.controller 'prob-modify-ctrl', [
  "$scope", "doffirst", "$routeParams"
  ($scope, doffirst, $route-params) ->
    if $route-params.pid
      pid = parse-int that
      doffirst.get "/problem/#{pid}/total", $scope, -> it <<< _id: pid
    else
      $scope.prob = {}
      doffirst.get "/problem/next-count", $scope.prob
    $scope.submit = ->
      console.log $scope.prob
      doffirst.put "/problem/#{$scope.prob._id}", $scope.prob
]
