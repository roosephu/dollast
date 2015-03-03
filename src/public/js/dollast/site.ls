app = angular.module 'dollast-site-app', ["dollast-crud"]

app.controller 'navbar-ctrl', [
  "$scope", "site-serv",
  ($scope, site-serv) ->
    $scope.users = site-serv.get mode: 'session'
]

app.controller 'index-ctrl', [
  "$scope", "site-serv", "$location"
  ($scope, site-serv, $location) ->
]

app.controller 'login-ctrl', [
  "$scope", "site-serv",
  ($scope, site-serv) ->
    $scope.submit = (user) ->
      site-serv.login $scope.user, ->
        $scope.msg = it.status == false
]
