_ = require 'prelude-ls'

app = angular.module 'dollast-rnd-app', ["dollast-crud", "ui.dateTimeInput"]

app.controller 'rnd-list-ctrl', [
  "$scope", "rnd-serv", "$routeParams"
  ($scope, rnd-serv, $route-params) ->
    $scope.rounds = rnd-serv.query!
]

app.controller 'rnd-show-ctrl', [
  "$scope", "rnd-serv", "$routeParams"
  ($scope, rnd-serv, $route-params) ->
    rid = parse-int $route-params.rid
    $scope.rnd = rnd-serv.get rid: rid
]

app.controller 'rnd-modify-ctrl', [
  "$scope", "rnd-serv", "prob-serv" "$routeParams"
  ($scope, rnd-serv, prob-serv, $route-params) ->
    $scope.pid = 0
    if $route-params.rid
      $scope.rnd = rnd-serv.get rid: that, mode: "total", ->
        $scope.probs = it.probs
    else
      rnd-serv.next-count ->
        $scope.rnd =
          _id: it._id
          beg-time: new Date Date.now!
          end-time: new Date Date.now!
        $scope.probs = []
        console.log "temp: #{JSON.stringify it}"
    $scope.submit = ->
      console.log $scope.rnd
      rid = $scope.rnd._id
      $scope.rnd.probs = _.map (._id), $scope.probs
      rnd-serv.save $scope.rnd
    $scope.insert = ->
      prob-serv.get pid: $scope.pid, mode: "brief", ->
        console.log "ret #{JSON.stringify it}"
        if it._id
          $scope.probs.push it
        else
          ...
    $scope.remove = (pid) ->
      $scope.probs = _.reject (._id == pid), $scope.probs
    $scope.delete = ->
      rnd-serv.delete rid: $scope.rnd._id
]

app.controller 'rnd-board-ctrl', [
  "$scope", "rnd-serv", "$routeParams",
  ($scope, rnd-serv, $route-params) ->
    rid = parse-int $route-params.rid
    $scope.board = rnd-serv.board rid: rid
    $scope.rnd = rnd-serv.get rid: rid
]
