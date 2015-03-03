require! {
  'koa-router'
  'debug'
  'util'
  'path'
  './config'
  './core'
}

tmp = bluebird.promisify require 'tmp'
db  = config.db
log = debug 'router'

prob-ctrl =
  list: ->*
    @body = yield db.prob.list!
  next-count: ->*
    @body = _id: yield db.prob.next-count!
  show: ->*
    pid = @params.pid
    @body = yield db.prob.show pid, mode: "view"
    console.log "body: #{util.inspect @body}"
  total: ->*
    pid = parse-int @params.pid
    @body = yield db.prob.show pid, mode: "total"
  save: ->*
    @body = yield db.prob.modify @params.pid, @request.body
  upload: ->*
    pid = parse-int @params.pid
    parts = co-busboy @, auto-fields: true
    while part = yield parts
      console.log "filename: #{part.filename}"
      yield core.upload pid, part
    console.log "done"
    @body = status: true
  delete: ->*
    ...

sol-ctrl =
  submit:  ->*
    uid ?= @session.passport.user?._id
    @body = status: yield db.sol.submit @request.body, uid
  list: ->*
    @body = yield db.sol.list!
  show: ->*
    @body = yield db.sol.show parse-int @params.sid

rnd-ctrl =
  list: ->*
    @body = yield db.rnd.list!
  next-count: ->*
    @body = _id: yield db.rnd.next-count!
  show: ->*
    rid = parse-int @params.rid
    @body = yield db.rnd.show rid, mode: "view"
  save: ->*
    rid = parse-int @params.rid
    @body = status: yield db.rnd.modify rid, @request.body
  total: ->*
    rid = parse-int @params.rid
    @body = yield db.rnd.show rid, mode: "total"
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

router = new koa-router!
router
  .get '/problem', prob-ctrl.list
  .get '/problem/next-count', prob-ctrl.next-count
  .get '/problem/:pid', prob-ctrl.show
  .get '/problem/:pid/total', prob-ctrl.total
  .post '/problem/:pid', prob-ctrl.save
  .post '/problem/:pid/upload', prob-ctrl.upload
  .delete '/problem/:pid', prob-ctrl.delete

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
