require! {
  'koa-router'
  'koa-jwt'
  'debug'
  'util'
  'path'
  'co-busboy'
  'bluebird'
  'prelude-ls': _
  './config'
  './core'
  "./db"
}

tmp = bluebird.promisify-all require 'tmp'
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
    @body = yield db.prob.list @query
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

image-ctrl =
  upload: ->*
    parts = co-busboy @, auto-fields: true
    while part = yield parts
      @body = link: yield core.upload-image part
    log @body

sol-ctrl =
  submit:  ->*
    uid = @user._id
    @body = status: yield db.sol.submit @request.body, uid
  list: ->*
    @body = yield db.sol.list @query
  show: ->*
    @body = yield db.sol.show @params.sid
  toggle: ->*
    @body = yield db.sol.toggle @params.sid

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
  login: ->*
    user = yield db.user.query @request.body
    if not user
      @body = status: "invalid"
    else
      priv-list = user.priv-list
      priv-list.push 'login'
      @session.priv = _.lists-to-obj priv-list, [true for i from 1 to priv-list.length]

      claims = _id: user._id
      token = koa-jwt.sign claims, config.secret, expire-in-minutes: 1
      @body = token: token, status: "OK"
  logout: ->*
    ...

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

reg-priv = (func) ->
  return ->*
    try
      yield func.call this
    catch err
      log err.message

router = new koa-router!
router
  .param 'pid', params-validator.pid
  .param 'sid', params-validator.sid
  .param 'rid', params-validator.rid

  .get    '/problem',                   reg-priv prob-ctrl.list
  .get    '/problem/next-count',        reg-priv prob-ctrl.next-count
  .get    '/problem/:pid',              reg-priv prob-ctrl.show     # in case viewing a invisible problem
  .get    '/problem/:pid/total',        reg-priv prob-ctrl.total
  .post   '/problem/:pid',              reg-priv prob-ctrl.save
  .delete '/problem/:pid',              reg-priv prob-ctrl.delete

  .get    '/data/:pid',                 reg-priv data-ctrl.show
  .post   '/data/:pid/upload',          reg-priv data-ctrl.upload

  .post   '/solution/submit',           reg-priv sol-ctrl.submit
  .get    '/solution',                  reg-priv sol-ctrl.list
  .get    '/solution/:sid',             reg-priv sol-ctrl.show
  .post   '/solution/:sid/toggle',      reg-priv sol-ctrl.toggle

  .get    '/round',                     reg-priv rnd-ctrl.list
  .get    '/round/next-count',          reg-priv rnd-ctrl.next-count
  .get    '/round/:rid',                reg-priv rnd-ctrl.show
  .post   '/round/:rid',                reg-priv rnd-ctrl.save
  .get    '/round/:rid/total',          reg-priv rnd-ctrl.total
  .delete '/round/:rid',                reg-priv rnd-ctrl.delete

  .get    '/site/theme/:theme',         reg-priv site-ctrl.theme
  .get    '/site/session',              reg-priv site-ctrl.session
  .get    '/site/session/login-token',  reg-priv site-ctrl.login-token
  .post   '/site/login',                reg-priv site-ctrl.login
  .post   '/site/logout',               reg-priv site-ctrl.logout

  .get    '/user/:uid/profile',         reg-priv user-ctrl.show
  .post   '/user/register/',            reg-priv user-ctrl.register
  .post   '/user/:uid/modify',          reg-priv user-ctrl.save

  .post   '/image/upload',              reg-priv image-ctrl.upload

export router = router.middleware!
