require! {
  \koa
  \koa-convert
  \koa-router
  \debug
  \co
  \co-busboy
  \./config
  \./core
  \./controllers : {data, problems, submissions, packs, site, users}
  \./Exception
}

log = debug \dollast:router

# params-validator =
#   pid: (pid, ctx, next) ->
#     ctx.params.pid = pid
#     # log {pid}, ctx.req
#     ctx.check-params \pid .to-int! .ge 0
#     return if ctx.errors
#     next!
#   sid: (sid, ctx, next) ->
#     ctx.params.sid = sid
#     ctx.check-params \sid .to-int! .ge 0
#     return if ctx.errors
#     next!
#   rid: (rid, ctx, next) ->
#     ctx.params.rid = rid
#     ctx.check-params \rid .to-int! .ge 0
#     return if ctx.errors
#     next!
#   uid: (uid, ctx, next) ->
#     ctx.params.uid = uid
#     ctx.check-params \uid .len config.uid-min-len, config.uid-max-len
#     return if ctx.errors
#     next!

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
  # .post   '/site/logout',               site.logout

  .post   '/user/register',             users.register
  .post   '/user/:user',                users.save
  .get    '/user/:user',                users.profile

  .get    '/pack',                      packs.list
  # .get    '/pack/next-count',           pack.next-count
  .get    '/pack/:pack',                packs.show
  .get    '/pack/:pack/board',          packs.board
  .post   '/pack',                      packs.save
  .delete '/pack/:pack',                packs.remove

  .get    '/problem',                   problems.list
  # .get    '/problem/next-count',        prob.next-count
  .get    '/problem/:problem',          problems.show
  .post   '/problem',                   problems.save
  .delete '/problem/:problem',          problems.remove
  .get    '/problem/:problem/stat',     problems.stat

  .get    '/submission',                submissions.list
  .get    '/submission/:submission',    submissions.show
  .post   '/submission',                submissions.submit
  # .post   '/submission/:sid/toggle',    submissions.toggle

  # .get    '/data/:pid',                 data.show
  .post   '/data/:problem/upload',      data.upload
  .get    '/data/:problem/rebuild',     data.rebuild
  .delete '/data/:problem/:file',       data.remove

app.use router.middleware!

module.exports = app
