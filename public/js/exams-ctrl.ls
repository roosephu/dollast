exams-app = angular.module 'exams-app', []

exams-app.controller 'exams-app-ctrl', ($scope, $http) ->
  $scope.send = (mode) ->
    console.log mode
    student-sol = {}
    for prob in $scope.problems
      student-sol[prob.id] = prob.sol
    console.log student-sol
    $http.post "/api/exams/#{mode}", student-sol
      .success (data, status, headers, config) ->
        console.log "#{mode} request received... but not implemented"
  $http.get '/api/exams/get'
    .success (data, status, headers, config) ->
      console.log data
      $scope.problems = data
      for prob in $scope.problems
        prob.sol = 'A'
    .error (data, status, headers, config) ->
      console.log 'Network Error'
      $scope.problems = []
