require! {
  \koa
  \koa-convert
  \koa-router
  \debug
  \co
  \co-busboy
  \./config
  \./core
  \./controllers : {data, problems, solutions, rounds, site, users}
  \./Exception
}

log = debug \dollast:router

params-validator =
  pid: (pid, ctx, next) ->
    ctx.params.pid = pid
    # log {pid}, ctx.req
    ctx.check-params \pid .to-int! .ge 0
    return if ctx.errors
    next!
  sid: (sid, ctx, next) ->
    ctx.params.sid = sid
    ctx.check-params \sid .to-int! .ge 0
    return if ctx.errors
    next!
  rid: (rid, ctx, next) ->
    ctx.params.rid = rid
    ctx.check-params \rid .to-int! .ge 0
    return if ctx.errors
    next!
  uid: (uid, ctx, next) ->
    ctx.params.uid = uid
    ctx.check-params \uid .len config.uid-min-len, config.uid-max-len
    return if ctx.errors
    next!

app = new koa!

app.use co.wrap (ctx, next) ->*
  ctx.errors = []
  ctx.throw = (err) ->
    throw new Exception err
  ctx.check-errors = ->
    if ctx.errors.length > 0
      throw new Exception
  ctx.assert = (expression, e) ->
    if !expression
      throw new Exception e

  # log "response:", ctx.body, ctx.errors
  log "#{ctx.req.method} #{ctx.req.url}:", ctx.request.body
  ctx.body = void
  try
    yield next!
  catch e
    if e instanceof Exception
      if e.error
        ctx.errors.push e.error
    else
      ctx.app.emit \error, e, ctx

  ctx.status = 200
  if ctx.errors.length > 0
    ctx.body = errors: ctx.errors
  else
    ctx.body = data: ctx.body
  log ctx.body

router = new koa-router!
router
  # .param \pid, params-validator.pid
  # .param \sid, params-validator.sid
  # .param \rid, params-validator.rid
  # .param \uid, params-validator.uid

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
  .post   '/problem',                   problems.save
  .put    '/problem/:pid',              problems.save
  .delete '/problem/:pid',              problems.remove
  .get    '/problem/:pid/stat',         problems.stat

  .get    '/solution',                  solutions.list
  .get    '/solution/:sid',             solutions.show
  .post   '/solution/submit',           solutions.submit
  # .post   '/solution/:sid/toggle',      solutions.toggle

  # .get    '/data/:pid',                 data.show
  .post   '/data/:pid/upload',          data.upload
  .get    '/data/:pid/rebuild',         data.rebuild
  .delete '/data/:pid/:file',           data.remove

app.use router.middleware!

module.exports = app
