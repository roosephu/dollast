login-app = angular.module 'login-app', []

login-app.controller 'login-app-ctrl', [
  "$scope",
  "$http",
  ($scope, $http) ->
    $scope.user =
      username: ''
      password: ''
    $scope.submit = (user) ->
      console.log user
      $http.post '/login', $scope.user
        .success (data, status, headers, config) ->
          console.log 'login OK'
        .error (data, status, headers, config) ->
          console.log 'login Error'
]
