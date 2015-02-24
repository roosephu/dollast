_ = require 'prelude-ls'

sol-app = angular.module 'dollast-rnd-app', ["doffirst", "ui.dateTimeInput"]

sol-app.controller 'rnd-list-ctrl', [
  "$scope", "doffirst", "$routeParams"
  ($scope, doffirst, $route-params) ->
    doffirst.get "/round", $scope
]

sol-app.controller 'rnd-show-ctrl', [
  "$scope", "doffirst", "$routeParams"
  ($scope, doffirst, $route-params) ->
    rid = parse-int $route-params.rid
    doffirst.get "/round/#{rid}", $scope
]

sol-app.controller 'rnd-modify-ctrl', [
  "$scope", "doffirst", "$routeParams"
  ($scope, doffirst, $route-params) ->
    $scope.pid = 0
    if $route-params.rid
      doffirst.get "/round/#{that}/total", $scope, ->
        it.rnd <<< _id: that
        it.probs = it.rnd.probs
    else
      doffirst.get "/round/next-count", $scope, ->
        it.rnd =
          _id: it._id
          beg-time: new Date Date.now!
          end-time: new Date Date.now!
        it.probs = []
        console.log "temp: #{JSON.stringify it.rnd}"
    $scope.submit = ->
      console.log $scope.rnd
      $scope.rnd.probs = _.map (._id), $scope.probs
      doffirst.put "/round/#{$scope.rnd._id}", $scope.rnd
    $scope.insert = ->
      new-prob = {}
      doffirst.get "/problem/#{$scope.pid}", new-prob, ->
        if it.prob
          $scope.probs.push it.prob
        else
          ...
    $scope.remove = (pid) ->
      $scope.probs = _.reject (._id == pid), $scope.probs
    $scope.delete = ->
      doffirst.delete "/round/#{$scope.rnd._id}"
]
