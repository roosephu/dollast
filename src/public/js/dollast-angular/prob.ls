prelude = require 'prelude-ls'

prob-app = angular.module 'dollast-prob-app', ["ngFileUpload", "dollast-crud", "ngSanitize", "ngCkeditor"]

prob-app.controller 'prob-show-ctrl', [
  "$scope", "prob-serv", "$routeParams", "$timeout"
  ($scope, prob-serv, $route-params, $timeout) ->
    $scope.pid = parse-int $route-params.pid
    $scope.prob = prob-serv.get pid: $scope.pid, ->
      $timeout ->
        MathJax.Hub.Queue ["Typeset", MathJax.Hub]
]

prob-app.controller 'prob-list-ctrl', [
  "$scope", "$routeParams", "prob-serv", "$timeout"
  ($scope, $route-params, prob-serv, $timeout) ->
    $scope.probs = prob-serv.query!
    $timeout ->
      $ '.filter.menu .item' .tab!
]

prob-app.controller 'prob-stat-ctrl', [
  "$scope", "$routeParams", "prob-serv",
  ($scope, $route-params, prob-serv) ->
    pid = $scope.pid = parse-int $route-params.pid
    prob-serv.stat pid: pid, ->
      $scope.sols = _.sort-by (.doc.final.score), it.sols
      console.log $scope.sols
]

prob-app.controller 'prob-modify-ctrl', [
  "$scope", "prob-serv", "data-serv", "$routeParams", "$sanitize", "$timeout", "$upload",
  ($scope, prob-serv, data-serv, $route-params, $sanitize, $timeout, $upload) ->
    $scope.editor-options =
      language: "en"
      extra-plugins: "autogrow"
      skin: 'minimalist'
    $scope.judgers = ["string", "real", "strict", "custom"]
    $scope.prob =
      config:
        judger: "string"
      outlook: {}
    $timeout ->
      $ '.ui.dropdown' .dropdown!
      $ '.ui.checkbox' .checkbox!

    if $route-params.pid
      method = "modify"
      pid = parse-int that
      $scope.prob = prob-serv.get pid: pid, mode: "total"
        .._id = pid
    else
      method = "create"
      $scope.prob = prob-serv.next-count ->
        it <<<
          config:
            judger: "string"
          outlook:
            desc: ""
    $scope.upload-file =
      flag: true
      name: ""

    $scope.del-data = (atom) ->
      pid = $scope.prob._id
      data-serv.delete pid: pid, file: atom.input, ->
        data-serv.delete pid: pid, file: atom.output, ->
          prob-serv.repair pid: pid
      $scope.prob.dataset = prelude.reject (.input == atom.input), $scope.prob.dataset

    $scope.submit = ->
      console.log $scope.prob
      prob-serv.save $scope.prob <<< method: method

    $scope.upload = ->
      console.log $scope.upload-file
      $upload.upload do
        url: "/data/#{$scope.prob._id}/upload"
        file: $scope.upload-file

    $scope.update-dataset-list = ->
      $scope.prob.config.dataset = data-serv.query pid: $scope.prob._id

    $scope.select = (judger) ->
      $scope.prob.config.judger = judger

    $scope.repair = ->
      prob-serv.repair pid: $scope.prob._id

]
