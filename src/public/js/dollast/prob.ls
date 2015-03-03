prob-app = angular.module 'dollast-prob-app', ["ngFileUpload", "dollast-crud"]

prob-app.controller 'prob-show-ctrl', [
  "$scope", "prob-serv", "$routeParams"
  ($scope, prob-serv, $route-params) ->
    $scope.pid = parse-int $route-params.pid
    $scope.prob = prob-serv.get pid: $scope.pid
]

prob-app.controller 'prob-list-ctrl', [
  "$scope", "$routeParams", "prob-serv"
  ($scope, $route-params, prob-serv) ->
    $scope.probs = prob-serv.query!
]

prob-app.controller 'prob-modify-ctrl', [
  "$scope", "prob-serv", "$routeParams", "$upload"
  ($scope, prob-serv, $route-params, $upload) ->
    if $route-params.pid
      pid = parse-int that
      $scope.prob = prob-serv.get pid: pid, mode: "total"
        .._id = pid
    else
      $scope.prob = prob-serv.next-count
    $scope.upload-file =
      flag: true
      name: ""

    $scope.submit = ->
      console.log $scope.prob
      pid = $scope.prob._id
      $scope.prob.$save!
      $scope.prob = prob-serv.get pid: pid
    $scope.upload = ->
      $upload.upload do
        url: "/problem/#{$scope.prob._id}/upload"
        file: $scope.upload-file
]
