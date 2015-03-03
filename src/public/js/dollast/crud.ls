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
        mode: 'login'
]

crud.service 'prob-serv', [
  "$resource"
  ($resource) ->
    $resource '/problem/:pid/:mode/', pid: '@_id',
      next-count:
        pid: 'next-count'
]

crud.service "rnd-serv", [
  "$resource",
  ($resource) ->
    $resource "/round/:rid/:mode", rid: '@_id',
      next-count:
        rid: 'next-count'
]

crud.service "sol-serv", [
  "$resource",
  ($resource) ->
    $resource "/solution/:sid/:mode", sid: '@_id',
      submit:
        method: 'POST'
]
