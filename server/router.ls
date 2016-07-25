require! {
  \koa
  \koa-joi-router
  \debug
  \./config
  \./core
  \./controllers : {data, problems, submissions, packs, site, users}
  \./Exception
}

log = debug \dollast:router

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

router = new koa-joi-router!

router.route packs
router.route data
router.route problems
router.route submissions
router.route users
router.route site

app.use router.middleware!

module.exports = app
