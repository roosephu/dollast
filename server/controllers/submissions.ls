require! {
  \co
  \prelude-ls : {Obj}
  \debug
  \../models
  \../core
  \../config
}

log = debug \dollast:ctrl:submission

export submit = co.wrap (ctx) ->*
  log {pid: ctx.request.body.pid}
  ctx.check-body \pid .is-int! .ge 1
  ctx.check-body \language .in [\cpp, \java]
  ctx.check-body \code .len 1, 50000
  ctx.check-body \user .empty!
  return if ctx.errors?.length > 0

  {pid, code, language, permit} = ctx.request.body
  log {pid}

  problem = yield models.problems.find-by-id pid, "permit config" .exec!
  ctx.assert problem, id: pid, type: \problem, detail: 'no problem found. '
  problem.permit.check-access ctx.state.user, \x

  {uid} = ctx.state.user.client

  # ctx.ensure-access model, 0, \x # sol = 0 => submision
  submission = new models.submissions do
    _id: yield models.submissions.next-count!
    code: code
    language: language
    problem: pid
    user: uid
    summary:
      status: \running
    permit: permit

  yield submission.save!
  core.judge language, code, problem.config, submission

  ctx.body = msg: "submission submited successfully"

export list = co.wrap (ctx) ->*
  # TODO: verify input
  opts = config.sol-list-opts with ctx.request.query

  basic-filters = Obj.reject (== undefined), opts{user, round, language}
  log {opts, basic-filters}

  query = models.submissions.find basic-filters, '-code -results'
    .populate \problem, 'outlook.title'
    .populate \round, 'title beginTime'
    .sort '-date'
    .lean!
  if opts.page
    query .= skip (opts.page - 1) * opts.limit
    query .= limit opts.limit
  if opts.relationship and opts.threshold
    switch opts.relationship
      | \lt => query .= where 'summary.score' .lte opts.threshold
      | \gt => query .= where 'summary.score' .gte opts.threshold

  submissions = yield query.exec!

  ctx.body = submissions

export show = co.wrap (ctx) ->*
  {sid} = ctx.params

  submission = yield models.submissions.find-by-id sid
    .populate \problem, 'outlook.title'
    .exec!
  ctx.assert submission, id: sid, type: \submission, detail: 'no submission found. '

  submission.permit.check-access ctx.state.user, \r

  ctx.body = submission
