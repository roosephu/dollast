require! {
  \koa-router
  \debug
  \co-busboy
  \./config
  \./core
  \./db
  \./controllers : {data, problems, solutions, rounds, site, users}
}

log = debug \dollast:router

image = # deprecated
  upload: ->*
    parts = co-busboy @, auto-fields: true
    while part = yield parts
      @body = link: yield core.upload-image part
    log @body

params-validator =
  pid: (pid, next) ->*
    @params.pid = pid
    # log {pid}, @req
    @check-params \pid .to-int! .ge 0
    return if @errors
    yield next
  sid: (sid, next) ->*
    @params.sid = sid
    @check-params \sid .to-int! .ge 0
    return if @errors
    yield next
  rid: (rid, next) ->*
    @params.rid = rid
    @check-params \rid .to-int! .ge 0
    return if @errors
    yield next
  uid: (uid, next) ->*
    @params.uid = uid
    @check-params \uid .len config.uid-min-len, config.uid-max-len
    return if @errors
    yield next

router = new koa-router!
router
  .param \pid, params-validator.pid
  .param \sid, params-validator.sid
  .param \rid, params-validator.rid
  .param \uid, params-validator.uid

  .get    '/site/theme/:theme',         site.theme
  # .get    '/site/session',              site.session
  .get    '/site/token',                site.token
  .post   '/site/login',                site.login
  .post   '/site/logout',               site.logout

  .post   '/user/register',             users.register
  .post   '/user/:uid',                 users.save
  .get    '/user/:uid',                 users.profile

  .get    '/round',                     rounds.list
  # .get    '/round/next-count',          rnd.next-count
  .get    '/round/:rid',                rounds.show
  .get    '/round/:rid/board',          rounds.board
  .post   '/round/:rid',                rounds.save
  .delete '/round/:rid',                rounds.remove

  .get    '/problem',                   problems.list
  # .get    '/problem/next-count',        prob.next-count
  .get    '/problem/:pid',              problems.show
  .post   '/problem/:pid',              problems.save
  .delete '/problem/:pid',              problems.remove
  .get    '/problem/:pid/stat',         problems.stat

  .get    '/solution',                  solutions.list
  .get    '/solution/:sid',             solutions.show
  .post   '/solution/submit',           solutions.submit
  # .post   '/solution/:sid/toggle',      solutions.toggle

  # .get    '/data/:pid',                 data.show
  .post   '/data/:pid/upload',          data.upload
  .get    '/data/:pid/repair',          data.repair
  .delete '/data/:pid/:file',           data.remove

export router = router.middleware!
