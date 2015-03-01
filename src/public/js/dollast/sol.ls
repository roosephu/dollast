sol-app = angular.module 'dollast-sol-app', ["doffirst", "ngRoute"]

sol-app.controller 'sol-submit-ctrl', [
  "$scope", "doffirst", "$routeParams", "$location"
  ($scope, doffirst, $route-params, $location) ->
    $scope.pid = parse-int $route-params.pid
    $scope.lang = 'C++'
    $scope.submit = ->
      doffirst.post '/submit',
        code: $scope.code
        pid: $scope.pid
        lang: $scope.lang
        {}
      $location.path "/solution"
]

sol-app.controller 'sol-list-ctrl', [
  "$scope", "doffirst", "$routeParams"
  ($scope, doffirst, $route-params) ->
    doffirst.get "/solution", $scope
]

sol-app.controller 'sol-show-ctrl', [
  "$scope", "doffirst", "$routeParams"
  ($scope, doffirst, $route-params) ->
    $scope.sid = parse-int $route-params.sid
    doffirst.get "/solution/#{$scope.sid}", $scope
]
