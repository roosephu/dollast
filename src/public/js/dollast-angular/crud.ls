crud = angular.module 'dollast-crud', ["ngResource"]

crud.config ["$resourceProvider", ($resource-provider) ->
  $resource-provider.defaults.strip-trailing-slashes = false
]

crud.service "site-serv", [
  "$resource",
  ($resource) ->
    $resource "/site/:mode/:param/", {},
      login:
        method: 'POST'
        params:
          mode: 'login'
]

crud.service 'prob-serv', [
  "$resource"
  ($resource) ->
    $resource '/problem/:pid/:mode/', pid: '@_ \i,d',
      next-count:
        params:
          pid: 'next-count'
      repair:
        params:
          mode: 'repair'
      stat:
        params:
          mode: 'stat'
]

crud.service "rnd-serv", [
  "$resource",
  ($resource) ->
    $resource "/round/:rid/:mode", rid: '@_ \i,d',
      next-count:
        params:
          rid: 'next-count'
      board:
        is-array: true
        params:
          mode: 'board'
]

crud.service "sol-serv", [
  "$resource",
  ($resource) ->
    $resource "/solution/:sid/:mode", sid: '@_ \i,d',
      submit:
        method: 'POST'
      toggle:
        method: 'POST'
        params:
          mode: 'toggle'
]

crud.service "data-serv", [
  "$resource",
  ($resource) ->
    $resource "/data/:pid/:file", sid: '@_ \i,d'
]

crud.service "user-serv", [
  "$resource"
  ($resource) ->
    $resource "/user/:uid/:mode", uid: '@_ \i,d',
      save:
        method: 'POST'
        params:
          mode: 'modify'
      get:
        params:
          mode: 'profile'
      reg:
        method: 'POST'
        params:
          uid: 'register'
]
