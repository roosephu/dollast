_ = require 'prelude-ls'

app = angular.module 'dollast-rnd-app', ["dollast-crud", "ui.dateTimeInput"]

app.controller 'rnd-list-ctrl', [
  "$scope", "rnd-serv", "$routeParams", "$timeout"
  ($scope, rnd-serv, $route-params, $timeout) ->
    $scope.rounds = rnd-serv.query!
    $timeout ->
      $ '.ui.checkbox' .checkbox!
]

app.controller 'rnd-show-ctrl', [
  "$scope", "rnd-serv", "$routeParams", "$timeout"
  ($scope, rnd-serv, $route-params, $timeout) ->
    rid = parse-int $route-params.rid
    $scope.state = cls: "striped", sty: width: "0%"
    $scope.rnd = rnd-serv.get rid: rid, ->
      bef = moment!.to-date! - moment it.beg-time
      aft = moment!.to-date! - moment it.end-time
      $scope.started = bef >= 0
      $scope.ended = aft >= 0
      if $scope.ended
        $scope.state = cls: "successful", sty: width: "100%"
      else if $scope.started
        $scope.state = cls: "active", sty: width: "#{100 * bef / (bef - aft)}%"

    $timeout ->
      $ '.filter.menu .item' .tab!

    $scope.publish = ->
      rnd-serv.get rid: rid, mode: "publish"
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
          _ \i,d: it._ \i,d
          beg-time: new Date Date.now!
          end-time: new Date Date.now!
        $scope.probs = []
    $scope.submit = ->
      console.log $scope.rnd
      rid = $scope.rnd._ \i,d
      $scope.rnd.probs = _.map (._ \i,d), $scope.probs
      rnd-serv.save $scope.rnd
    $scope.insert = ->
      prob-serv.get pid: $scope.pid, mode: "brief", ->
        console.log it
        if it._ \i,d
          $scope.probs.push it
        else
          ...
    $scope.remove = (pid) ->
      $scope.probs = _.reject (._ \i,d == pid), $scope.probs
    $scope.delete = ->
      rnd-serv.delete rid: $scope.rnd._ \i,d
]

fmt-results = (sols) ->
  results = {}
  for sol in sols
    {user, prob} = sol._ \i,d
    results[user] ||= {}
    results[user][prob] ||= {}

    cur = results[user][prob]
    if not cur._ \i,d? or cur._ \i,d < sol.sid
      cur <<< _ \i,d: sol.sid, score: sol.score

  for user, value of results
    results[user].total = value |> _.values |> _.map (.score) |> _.sum
  return results

app.controller 'rnd-board-ctrl', [
  "$scope", "rnd-serv", "$routeParams",
  ($scope, rnd-serv, $route-params) ->
    rid = parse-int $route-params.rid
    rnd-serv.board rid: rid, ->
      $scope.board = fmt-results it
    $scope.rnd = rnd-serv.get rid: rid
]
