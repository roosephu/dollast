require! {
  \koa
  \koa-joi-router
  \debug
  \flat
  \./config
  \./core
  \./controllers : {data, problems, submissions, packs, site, users, error}
}

log = debug \dollast:router

app = new koa!

app.use (next) ->*
  @errors = []
  @assert = (statement, _id, type, detail) ->
    if !statement
      throw new error _id, type, detail

  # log "response:", @body, @errors
  log "#{@req.method} #{@req.url}:", @request.body
  try
    yield next
  catch e
    if e instanceof Error
      if e.name == \ValidationError
        object = flat e._object
        log e.details
        for detail in e.details
          @errors.push do
            _id: @req.url
            type: \Request
            detail: "#{detail.message}, instead of '#{object[detail.path]}'"
      else if e.re
        e.errors.push e.error
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
