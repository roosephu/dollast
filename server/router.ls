require! {
  \koa
  \koa-joi-router
  \debug
  \flat
  \./config
  \./models
  \./core
  \./controllers : {data, problems, submissions, rounds, site, users}
  \./controllers/err
}

log = debug \dollast:router

app = new koa!

trigger-round = ->>
  while true
    round = await models.Rounds.find-one flag: true, '' .sort \endTime .exec!
    if round.end-time < new Date!
      log "trigger Round #{round._id}"
      round.flag = false
      await round.save!

      submissions = await models.Submissions.find round: round._id, hidden: true, 'config.permit' .exec!
      for submission in submissions
        submission.hidden = false
        await submission.save!
    else
      break

app.use (ctx, next) ->>

  ctx.errors = []
  ctx.assert = err.assert
  ctx.assert-exist = err.assert-exist
  ctx.assert-name = err.assert-name

  await trigger-round!

  # log "response:", @body, @errors
  log "#{ctx.req.method} #{ctx.req.url}:", ctx.request.body
  try
    await next!
  catch e
    if e.name == \ValidationError
      ctx.errors.push e{name, details, _object}
    else if e.re
      ctx.errors.push e{name, details}
      log \RuntimeError, e.error
    else
      throw e
      ctx.app.emit \error, e, @

  ctx.status = 200
  if ctx.errors.length > 0
    ctx.body = errors: ctx.errors
  else
    ctx.body = data: ctx.body

router = new koa-joi-router!

router.route rounds
router.route data
router.route problems
router.route submissions
router.route users
router.route site

app.use router.middleware!

module.exports = app
