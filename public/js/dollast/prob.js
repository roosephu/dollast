// Generated by LiveScript 1.3.1
var probApp;
probApp = angular.module('dollast-prob-app', ["ngFileUpload", "dollast-crud"]);
probApp.controller('prob-show-ctrl', [
  "$scope", "prob-serv", "$routeParams", function($scope, probServ, $routeParams){
    $scope.pid = parseInt($routeParams.pid);
    return $scope.prob = probServ.get({
      pid: $scope.pid
    });
  }
]);
probApp.controller('prob-list-ctrl', [
  "$scope", "$routeParams", "prob-serv", function($scope, $routeParams, probServ){
    return $scope.probs = probServ.query();
  }
]);
probApp.controller('prob-modify-ctrl', [
  "$scope", "prob-serv", "data-serv", "$routeParams", "$upload", function($scope, probServ, dataServ, $routeParams, $upload){
    var that, pid, x$;
    if (that = $routeParams.pid) {
      pid = parseInt(that);
      x$ = $scope.prob = probServ.get({
        pid: pid,
        mode: "total"
      });
      x$._id = pid;
    } else {
      $scope.prob = probServ.nextCount(function(it){
        return it.config.judger = "string";
      });
    }
    $scope.uploadFile = {
      flag: true,
      name: ""
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
    return $scope.updateDatasetList = function(){
      return $scope.prob.config.dataset = dataServ.query({
        pid: $scope.prob._id
      });
    };
  }
]);