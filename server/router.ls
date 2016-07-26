require! {
  \koa
  \koa-joi-router
  \debug
  \flat
  \./config
  \./core
  \./controllers : {data, problems, submissions, packs, site, users}
  \./controllers/err
}

log = debug \dollast:router

app = new koa!

app.use (next) ->*
  @errors = []
  @assert = err.assert

  # log "response:", @body, @errors
  log "#{@req.method} #{@req.url}:", @request.body
  try
    yield next
  catch e
    if e.name == \ValidationError
      log e.details
      for detail in e.details
        @errors.push do
          _id: @req.url
          type: \Request
          detail: "#{detail.message}, instead of '#{detail.context.value}'"
          field: detail.context.key
    else if e.re
      @errors.push e.error
      log \RuntimeError, e.error
    else
      throw e
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
