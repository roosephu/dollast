require! {
  'koa-router'
  'koa-jwt'
  'koa-validate'
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
    @check-params 'pid' .to-int! .ge 1
    return if @errors
    yield next
  sid: (sid, next) ->*
    @params.sid = sid
    @check-params 'sid' .to-int! .ge 1
    return if @errors
    yield next
  rid: (rid, next) ->*
    @params.rid = rid
    @check-params 'rid' .to-int! .ge 1
    return if @errors
    yield next
  uid: (uid, next) ->*
    @params.uid = uid
    @check-params 'uid' .len 6, 15
    return if @errors
    yield next

router = new koa-router!
router
  .param 'pid', params-validator.pid
  .param 'sid', params-validator.sid
  .param 'rid', params-validator.rid
  .param 'uid', params-validator.uid

  .get    '/problem',                   prob.list
  .get    '/problem/next-count',        prob.next-count
  .get    '/problem/:pid',              prob.show     # in case viewing a invisible problem
  .get    '/problem/:pid/brief',        prob.brief
  .get    '/problem/:pid/total',        prob.total
  .get    '/problem/:pid/repair',       prob.repair
  .get    '/problem/:pid/stat',         prob.stat
  .post   '/problem/:pid',              prob.save
  .delete '/problem/:pid',              prob.delete

  .get    '/data/:pid',                 data.show
  .post   '/data/:pid/upload',          data.upload
  .delete '/data/:pid/:file',           data.delete

  .post   '/solution/submit',           sol.submit
  .get    '/solution',                  sol.list
  .get    '/solution/:sid',             sol.show
  .post   '/solution/:sid/toggle',      sol.toggle

  .get    '/round',                     rnd.list
  .get    '/round/next-count',          rnd.next-count
  .get    '/round/:rid',                rnd.show
  .post   '/round/:rid',                rnd.save
  .get    '/round/:rid/total',          rnd.total
  .delete '/round/:rid',                rnd.delete
  .get    '/round/:rid/board',          rnd.board

  .get    '/site/theme/:theme',         site.theme
  .get    '/site/session',              site.session
  .get    '/site/session/login-token',  site.login-token
  .post   '/site/login',                site.login
  .post   '/site/logout',               site.logout

  .get    '/user/:uid/profile',         user.profile
  .post   '/user/register/',            user.register
  .post   '/user/:uid/modify',          user.save

  .post   '/image/upload',              image.upload

export router = router.middleware!
