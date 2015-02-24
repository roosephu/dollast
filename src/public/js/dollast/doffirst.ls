doffirst = angular.module 'doffirst', []
doffirst.service 'doffirst', ['$http',
  class
    (@$http) ->
      @caller = (obj, opts, cb, http) ->
        suc-cb = (obj, opts, cb, data, status, headers, config) -->
          if 'undefined' == typeof opts
            opts = {}
          else if 'function' == typeof opts
            cb = opts
            opts = {}
          if opts.debug
            console.log "data: #{JSON.stringify data}"
          if obj
            obj <<< data
            cb obj if cb
        http.success suc-cb obj, opts, cb
    get: (url, obj, opts, cb) ->
      @caller obj, opts, cb, @$http.get url
    put: (url, data, obj, opts, cb) ->
      @caller obj, opts, cb, @$http.put url, data
    post: (url, data, obj, opts, cb) ->
      @caller obj, opts, cb, @$http.post url, data
    delete: (url, obj, opts, cb) ->
      @caller obj, opts, cb, @$http.delete url
]
