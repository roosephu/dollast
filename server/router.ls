require! {
  \koa
  \koa-joi-router
  \debug
  \flat
  \./config
  \./models
  \./core
  \./controllers : {data, problems, submissions, packs, site, users}
  \./controllers/err
}

log = debug \dollast:router

app = new koa!

trigger-pack = ->*
  while true
    pack = yield models.Packs.find-one flag: true, '' .sort 'endTime' .exec!
    if pack.end-time < new Date!
      log "trigger Pack #{pack._id}"
      pack.flag = false
      yield pack.save!

      submissions = yield models.Submissions.find pack: pack._id, hidden: true, 'config.permit' .exec!
      for submission in submissions
        submission.hidden = false
        yield submission.save!
    else
      break

app.use (next) ->*

  @errors = []
  @assert = err.assert
  @assert-exist = err.assert-exist
  @assert-name = err.assert-name

  yield trigger-pack!

  # log "response:", @body, @errors
  log "#{@req.method} #{@req.url}:", @request.body
  try
    yield next
  catch e
    if e.name == \ValidationError
      @errors.push e{name, details, _object}
    else if e.re
      @errors.push e{name, details}
      log \RuntimeError, e.error
    else
      throw e
      @app.emit \error, e, @

  @status = 200
  if @errors.length > 0
    @body = errors: @errors
  else
    @body = data: @body

router = new koa-joi-router!

router.route packs
router.route data
router.route problems
router.route submissions
router.route users
router.route site

app.use router.middleware!

module.exports = app
