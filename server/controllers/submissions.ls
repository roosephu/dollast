require! {
  \co
  \prelude-ls : {Obj}
  \debug
  \../models
  \../core
  \../config
}

log = debug \dollast:ctrl:submission

export submit = ->*
  # @check-body \pid .is-int! .ge 1
  @check-body \language .in [\cpp, \java]
  @check-body \code .len 1, 50000
  @check-body \user .empty!
  return if @errors?.length > 0

  {problem, code, language, permit} = @request.body

  problem = yield models.problems.find-by-id problem, "permit config" 
    .populate 'config.pack', 'title' 
    .exec!
  @assert problem, id: problem._id, type: \problem, detail: 'no problem found. '
  problem.permit.check-access @state.user, \x

  pack = problem.config.pack._id
  {user} = @state.user.client

  # @ensure-access model, 0, \x # sol = 0 => submission
  submission = new models.submissions do
    _id: yield models.submissions.next-count!
    code: code
    language: language
    problem: problem._id
    user: user
    pack: pack
    summary:
      status: \running
    permit: permit

  yield submission.save!
  core.judge language, code, problem.config, submission

  @body = msg: "submission submited successfully"

export list = ->*
  # TODO: verify input
  opts = config.sol-list-opts with @request.query

  basic-filters = Obj.reject (== undefined), opts{user, pack, language}
  log {opts, basic-filters}

  query = models.submissions.find basic-filters, '-code -results'
    .populate \problem, 'outlook.title'
    .populate \pack, 'title beginTime'
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

  @body = submissions

export show = ->*
  {submission} = @params

  submission = yield models.submissions.find-by-id submission
    .populate \problem, 'outlook.title'
    .exec!
  @assert submission, id: submission, type: \submission, detail: 'no submission found. '

  submission.permit.check-access @state.user, \r

  @body = submission
