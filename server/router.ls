require! {
  \koa
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
#   pid: (pid, @, next) ->
#     @params.pid = pid
#     # log {pid}, @req
#     @check-params \pid .to-int! .ge 0
#     return if @errors
#     next!
#   sid: (sid, @, next) ->
#     @params.sid = sid
#     @check-params \sid .to-int! .ge 0
#     return if @errors
#     next!
#   rid: (rid, @, next) ->
#     @params.rid = rid
#     @check-params \rid .to-int! .ge 0
#     return if @errors
#     next!
#   uid: (uid, @, next) ->
#     @params.uid = uid
#     @check-params \uid .len config.uid-min-len, config.uid-max-len
#     return if @errors
#     next!

app = new koa!

app.use (next) ->*
  @errors = []
  @throw = (err) ->
    throw new Exception err
  @check-errors = ->
    if @errors.length > 0
      throw new Exception
  @assert = (expression, e) ->
    if !expression
      throw new Exception e

  # log "response:", @body, @errors
  log "#{@req.method} #{@req.url}:", @request.body
  @body = void
  try
    yield next
  catch e
    if e instanceof Exception
      if e.error
        @errors.push e.error
    else
      @app.emit \error, e, @

  @status = 200
  if @errors.length > 0
    @body = errors: @errors
  else
    @body = data: @body
  log @body

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
