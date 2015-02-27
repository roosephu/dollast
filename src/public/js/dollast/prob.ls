prob-app = angular.module 'dollast-prob-app', ["doffirst", "ngFileUpload"]

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
  "$scope", "doffirst", "$routeParams", "$upload"
  ($scope, doffirst, $route-params, $upload) ->
    if $route-params.pid
      pid = parse-int that
      doffirst.get "/problem/#{pid}/total", $scope, -> it <<< _id: pid
    else
      $scope.prob = {}
      doffirst.get "/problem/next-count", $scope.prob
    $scope.upload-file =
      flag: true
      name: ""

    $scope.submit = ->
      console.log $scope.prob
      doffirst.put "/problem/#{$scope.prob._id}", $scope.prob
    $scope.upload = ->
      console.log $scope.upload-file
      $upload.upload do
        url: "/problem/#{$scope.prob._id}/upload"
        file: $scope.upload-file
    $scope.$watch 'uploadFile', (old-val, new-val) ->
      console.log "#{new-val}"
]
