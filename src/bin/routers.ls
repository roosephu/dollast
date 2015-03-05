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
    log @session
    @body = uid: if @session.passport?.user?._id? then that else void

user-ctrl =
  show: ->*
    @body = yield db.user.show @params.uid
  save: ->*
    @body = status: yield db.user.modify @request.body
  register: ->*
    @body = status: yield db.user.register @request.body

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

reg-priv = (acquired-priv, func) ->
  let
    check-privilege = (priv) ->*
      for priv in _.words @session.passport.priv-list
        if priv == "login" and not @session.passport.user
          return false
        else
          if not user
            user = yield db.user.model.find-by-id user, "priv-list"
          if not user.query-priv priv
            return false
      return true

    (next) ->*
      if false # and check-privilege!
        @body = status: "privilege acquired"
      else
        yield func.call this

router = new koa-router!
router
  .param 'pid', params-validator.pid
  .param 'sid', params-validator.sid
  .param 'rid', params-validator.rid

  .get '/problem',                      reg-priv 'login'    , prob-ctrl.list
  .get '/problem/next-count',           reg-priv 'prob-all' , prob-ctrl.next-count
  .get '/problem/:pid',                 reg-priv 'login'    , prob-ctrl.show     # in case viewing a invisible problem
  .get '/problem/:pid/total',           reg-priv 'prob-all' , prob-ctrl.total
  .post '/problem/:pid',                reg-priv 'prob-all' , prob-ctrl.save
  .delete '/problem/:pid',              reg-priv 'prob-all' , prob-ctrl.delete

  .get '/data/:pid',                    reg-priv 'prob-all' , data-ctrl.show
  .post '/data/:pid/upload',            reg-priv 'prob-all' , data-ctrl.upload

  .post '/solution/submit',             reg-priv 'login'    , sol-ctrl.submit
  .get '/solution',                     reg-priv ''         , sol-ctrl.list
  .get '/solution/:sid',                reg-priv 'sol-all'  , sol-ctrl.show

  .get '/round',                        reg-priv 'login'    , rnd-ctrl.list
  .get '/round/next-count',             reg-priv 'rnd-all'  , rnd-ctrl.next-count
  .get '/round/:rid',                   reg-priv 'login'    , rnd-ctrl.show
  .post '/round/:rid',                  reg-priv 'rnd-all'  , rnd-ctrl.save
  .get '/round/:rid/total',             reg-priv 'rnd-all'  , rnd-ctrl.total
  .delete '/round/:rid',                reg-priv 'rnd-all'  , rnd-ctrl.delete

  .get '/site/theme/:theme',            reg-priv 'login'    , site-ctrl.theme
  .get '/site/session',                 reg-priv ''         , site-ctrl.session
  .get '/site/session/login-token',     reg-priv ''         , site-ctrl.login-token

  .get '/user/:uid/profile',            reg-priv ''         , user-ctrl.show
  .post '/user/register/',              reg-priv ''         , user-ctrl.register
  .post '/user/:uid/modify',            reg-priv ''         , user-ctrl.save

export private-router = router.middleware!
