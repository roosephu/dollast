prelude = require 'prelude-ls'

prob-app = angular.module 'dollast-prob-app', ["ngFileUpload", "dollast-crud", "ngSanitize", "ngCkeditor"]

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

    $ '.filter.menu .item' .tab!
]

prob-app.controller 'prob-modify-ctrl', [
  "$scope", "prob-serv", "data-serv", "$routeParams", "$upload", "$sanitize"
  ($scope, prob-serv, data-serv, $route-params, $upload, $sanitize) ->
    $scope.editor-options =
      language: "en"
      extra-plugins: "autogrow"
      skin: 'minimalist'

    if $route-params.pid
      pid = parse-int that
      $scope.prob = prob-serv.get pid: pid, mode: "total"
        .._id = pid
    else
      $scope.prob = prob-serv.next-count ->
        it.config.judger = "string"
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
      prob-serv.save $scope.prob
    $scope.upload = ->
      $upload.upload do
        url: "/data/#{$scope.prob._id}/upload"
        file: $scope.upload-file
    $scope.update-dataset-list = ->
      $scope.prob.config.dataset = data-serv.query pid: $scope.prob._id
]
