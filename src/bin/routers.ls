require! {
  'koa-router'
  'koa-validate'
  'debug'
  'util'
  'path'
  'co-busboy'
  'bluebird'
  'prelude-ls' : _
  './config'
  './core'
  "./db"
}

log = debug 'dollast:router'

image = # deprecated
  upload: ->*
    parts = co-busboy @, auto-fields: true
    while part = yield parts
      @body = link: yield core.upload-image part
    log @body

data = require './ctrls/data'
prob = require "./ctrls/prob"
sol  = require './ctrls/sol'
rnd  = require './ctrls/rnd'
site = require './ctrls/site'
user = require './ctrls/user'

params-validator =
  pid: (pid, next) ->*
    @params.pid = pid
    # log {pid}, @req
    @check-params 'pid' .to-int! .ge 0
    return if @errors
    yield next
  sid: (sid, next) ->*
    @params.sid = sid
    @check-params 'sid' .to-int! .ge 1
    return if @errors
    yield next
  rid: (rid, next) ->*
    @params.rid = rid
    @check-params 'rid' .to-int! .ge 0
    return if @errors
    yield next
  uid: (uid, next) ->*
    @params.uid = uid
    @check-params 'uid' .len config.uid-min-len, config.uid-max-len
    return if @errors
    yield next

router = new koa-router!
router
  .param 'pid', params-validator.pid
  .param 'sid', params-validator.sid
  .param 'rid', params-validator.rid
  .param 'uid', params-validator.uid

  .get    '/site/theme/:theme',         site.theme
  # .get    '/site/session',              site.session
  .get    '/site/token',                site.token
  .post   '/site/login',                site.login
  .post   '/site/logout',               site.logout

  .post   '/user/register',             user.register
  .post   '/user/:uid',                 user.save
  .get    '/user/:uid/profile',         user.profile
  .get    '/user/:uid/privileges',      user.get-privileges

  .get    '/round',                     rnd.list
  # .get    '/round/next-count',          rnd.next-count
  .get    '/round/:rid',                rnd.show
  .get    '/round/:rid/board',          rnd.board
  .post   '/round/:rid',                rnd.save
  .get    '/round/:rid/total',          rnd.total
  .get    '/round/:rid/publish',        rnd.publish
  .delete '/round/:rid',                rnd.remove

  .get    '/problem',                   prob.list
  # .get    '/problem/next-count',        prob.next-count
  .get    '/problem/:pid',              prob.show
  .post   '/problem/:pid',              prob.save
  .delete '/problem/:pid',              prob.delete
  .get    '/problem/:pid/brief',        prob.brief
  .get    '/problem/:pid/total',        prob.total
  .get    '/problem/:pid/repair',       prob.repair
  .get    '/problem/:pid/stat',         prob.stat

  .get    '/solution',                  sol.list
  .get    '/solution/:sid',             sol.show
  .post   '/solution/submit',           sol.submit
  .post   '/solution/:sid/toggle',      sol.toggle

  .get    '/data/:pid',                 data.show
  .post   '/data/:pid/upload',          data.upload
  .delete '/data/:pid/:file',           data.delete

export router = router.middleware!
