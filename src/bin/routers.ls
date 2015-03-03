require! {
  'koa-router'
  'debug'
  'util'
  'path'
  'co-busboy'
  'bluebird'
  './config'
  './core'
}

tmp = bluebird.promisify-all require 'tmp'
db  = config.db
log = debug 'router'

data-ctrl =
  upload: ->*
    pid = @params.pid
    parts = co-busboy @, auto-fields: true
    while part = yield parts
      @body = yield core.upload pid, part
    yield db.prob.upd-data pid
  delete: ->*
    ...
  show: ->*
    data = yield db.prob.list-dataset @params.pid
    @body = data

prob-ctrl =
  list: ->*
    @body = yield db.prob.list!
    log "prob-list #{@body}"
  next-count: ->*
    @body = _id: yield db.prob.next-count!
  show: ->*
    @body = yield db.prob.show @params.pid, mode: "view"
    console.log "body: #{util.inspect @body}"
  total: ->*
    @body = yield db.prob.show @params.pid, mode: "total"
  save: ->*
    @body = yield db.prob.modify @params.pid, @request.body
  delete: ->*
    ...

sol-ctrl =
  submit:  ->*
    uid ?= @session.passport.user?._id
    @body = status: yield db.sol.submit @request.body, uid
  list: ->*
    @body = yield db.sol.list!
  show: ->*
    @body = yield db.sol.show @params.sid

rnd-ctrl =
  list: ->*
    @body = yield db.rnd.list!
  next-count: ->*
    @body = _id: yield db.rnd.next-count!
  show: ->*
    @body = yield db.rnd.show @params.rid, mode: "view"
  save: ->*
    @body = status: yield db.rnd.modify @params.rid, @request.body
  total: ->*
    @body = yield db.rnd.show @params.rid, mode: "total"
  delete: ->*
    @body = status: yield db.rnd.delete @params.rid

site-ctrl =
  theme: ->*
    @session.theme = @params.theme
    @body = status: true
  login-token: ->*
    ...
    @body = @session.login-token = 1
  session: ->*
    @body = uid: if @session.passport?.user?._id? then that else void

params-validator =
  pid: (pid, next) ->*
    @params.pid = parse-int pid
    yield next
  sid: (sid, next) ->*
    @params.sid = parse-int sid
    yield next
  rid: (rid, next) ->*
    @params.rid = parse-int rid
    yield next

router = new koa-router!
router
  .param 'pid', params-validator.pid
  .param 'sid', params-validator.sid
  .param 'rid', params-validator.rid

  .get '/problem', prob-ctrl.list
  .get '/problem/next-count', prob-ctrl.next-count
  .get '/problem/:pid', prob-ctrl.show
  .get '/problem/:pid/total', prob-ctrl.total
  .post '/problem/:pid', prob-ctrl.save
  .delete '/problem/:pid', prob-ctrl.delete

  .get '/data/:pid', data-ctrl.show
  .post '/data/:pid/upload', data-ctrl.upload

  .post '/solution/submit', sol-ctrl.submit
  .get '/solution', sol-ctrl.list
  .get '/solution/:sid', sol-ctrl.show

  .get '/round', rnd-ctrl.list
  .get '/round/next-count', rnd-ctrl.next-count
  .get '/round/:rid', rnd-ctrl.show
  .post '/round/:rid', rnd-ctrl.save
  .get '/round/:rid/total', rnd-ctrl.total
  .delete '/round/:rid', rnd-ctrl.delete

  .get '/site/theme/:theme', site-ctrl.theme
  .get '/site/session', site-ctrl.session
  .get '/site/session/login-token', site-ctrl.login-token

export private-router = router.middleware!
