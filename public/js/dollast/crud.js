// Generated by LiveScript 1.3.1
var crud;
crud = angular.module('dollast-crud', ["ngResource"]);
crud.config([
  "$resourceProvider", function($resourceProvider){
    return $resourceProvider.defaults.stripTrailingSlashes = false;
  }
]);
crud.service("site-serv", [
  "$resource", function($resource){
    return $resource("/site/:mode/:param/", {}, {
      login: {
        method: 'POST',
        params: {
          mode: 'login'
        }
      }
    });
  }
]);
crud.service('prob-serv', [
  "$resource", function($resource){
    return $resource('/problem/:pid/:mode/', {
      pid: '@_id'
    }, {
      nextCount: {
        params: {
          pid: 'next-count'
        }
      }
    });
  }
]);
crud.service("rnd-serv", [
  "$resource", function($resource){
    return $resource("/round/:rid/:mode", {
      rid: '@_id'
    }, {
      nextCount: {
        params: {
          rid: 'next-count'
        }
      }
    });
  }
]);
crud.service("sol-serv", [
  "$resource", function($resource){
    return $resource("/solution/:sid/:mode", {
      sid: '@_id'
    }, {
      submit: {
        method: 'POST'
      }
    });
  }
]);
crud.service("data-serv", [
  "$resource", function($resource){
    return $resource("/data/:pid/:mode", {
      sid: '@_id'
    });
  }
]);
crud.service("user-serv", [
  "$resource", function($resource){
    return $resource("/user/:uid/:mode", {
      uid: '@_id'
    }, {
      save: {
        method: 'POST',
        params: {
          mode: 'modify'
        }
      },
      get: {
        params: {
          mode: 'profile'
        }
      },
      reg: {
        method: 'POST',
        params: {
          uid: 'register'
        }
      }
    });
  }
]);