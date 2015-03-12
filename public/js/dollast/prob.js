// Generated by LiveScript 1.3.1
var prelude, probApp;
prelude = require('prelude-ls');
probApp = angular.module('dollast-prob-app', ["ngFileUpload", "dollast-crud", "ngSanitize", "ngCkeditor"]);
probApp.controller('prob-show-ctrl', [
  "$scope", "prob-serv", "$routeParams", "$timeout", function($scope, probServ, $routeParams, $timeout){
    $scope.pid = parseInt($routeParams.pid);
    return $scope.prob = probServ.get({
      pid: $scope.pid
    }, function(){
      return $timeout(function(){
        return MathJax.Hub.Queue(["Typeset", MathJax.Hub]);
      });
    });
  }
]);
probApp.controller('prob-list-ctrl', [
  "$scope", "$routeParams", "prob-serv", "$timeout", function($scope, $routeParams, probServ, $timeout){
    $scope.probs = probServ.query();
    return $timeout(function(){
      return $('.filter.menu .item').tab();
    });
  }
]);
probApp.controller('prob-modify-ctrl', [
  "$scope", "prob-serv", "data-serv", "$routeParams", "$upload", "$sanitize", "$timeout", function($scope, probServ, dataServ, $routeParams, $upload, $sanitize, $timeout){
    var that, pid, x$;
    $scope.editorOptions = {
      language: "en",
      extraPlugins: "autogrow",
      skin: 'minimalist'
    };
    $scope.judgers = ["string", "real", "strict", "custom"];
    $scope.prob = {
      config: {
        judger: "string"
      },
      outlook: {}
    };
    $timeout(function(){
      return $('.ui.dropdown').dropdown();
    });
    if (that = $routeParams.pid) {
      pid = parseInt(that);
      x$ = $scope.prob = probServ.get({
        pid: pid,
        mode: "total"
      });
      x$._id = pid;
    } else {
      $scope.prob = probServ.nextCount(function(it){
        return it.config = {
          judger: "string"
        }, it.outlook = {
          desc: ""
        }, it;
      });
    }
    $scope.uploadFile = {
      flag: true,
      name: ""
    };
    $scope.delData = function(atom){
      var pid;
      pid = $scope.prob._id;
      dataServ['delete']({
        pid: pid,
        file: atom.input
      }, function(){
        return dataServ['delete']({
          pid: pid,
          file: atom.output
        }, function(){
          return probServ.repair({
            pid: pid
          });
        });
      });
      return $scope.prob.dataset = prelude.reject(function(it){
        return it.input === atom.input;
      }, $scope.prob.dataset);
    };
    $scope.submit = function(){
      console.log($scope.prob);
      return probServ.save($scope.prob);
    };
    $scope.upload = function(){
      return $upload.upload({
        url: "/data/" + $scope.prob._id + "/upload",
        file: $scope.uploadFile
      });
    };
    $scope.updateDatasetList = function(){
      return $scope.prob.config.dataset = dataServ.query({
        pid: $scope.prob._id
      });
    };
    return $scope.select = function(judger){
      return $scope.prob.config.judger = judger;
    };
  }
]);