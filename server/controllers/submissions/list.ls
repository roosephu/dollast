require! {
  \prelude-ls : {Obj}
  \debug
  \koa-joi-router : {Joi}
  \../validator
  \../../models
  \../../../common/options
}

log = debug \dollast:ctrl:submissions:list

handler = async (ctx) ->
  opts = options.sol-list-opts with ctx.request.query

  basic-filters = Obj.reject (== undefined), opts{user, pack, language, problem}
  if basic-filters.problem
    delete basic-filters.pack
  log {opts, basic-filters}

  query = models.Submissions.find basic-filters, '-code -results'
    .populate \problem, 'outlook.title'
    .populate \pack, 'title endTime'
    .sort '-date'
    .lean!
  if opts.page
    query .= skip (opts.page - 1) * opts.limit
    query .= limit opts.limit
  if opts.relationship in [\lt, \gt] and opts.threshold
    log \???
    # if current user is the owner of request pack, then he can see all submissions
    check = false
    if ctx.state.user.admin?
      check = true
    else if opts.pack
      pack = await models.Packs.find-by-id opts.pack, \permit .exec!
      if pack.permit.check-owner ctx.state.user
        check = true

    fn = 'summary.score':
      switch opts.relationship
        | \lt => $lte: opts.threshold
        | \gt => $gte: opts.threshold

    if not check
      log 'show public submissions'
      query .= and ['hidden': true, fn]
    else
      log 'show hidden submissions'
      query .= where fn
  if opts.before or opts.after
    query .= where 'date'
    if opts.before
      query .= lte opts.before
    if opts.after
      query .= gte opts.after

  submissions = await query.exec!
  current-time = new Date!
  for submission in submissions
    if submission.pack.endTime > current-time
      submission.summary =
        status: \hidden

  ctx.body = submissions

module.exports =
  method: \GET
  path: \/submission
  validate:
    query:
      user: validator.user!.optional!
      pack: validator.pack!.optional!
      problem: validator.problem!.optional!
      page: Joi .number! .min 0
      language: Joi .string! .equal options.languages
      threshold: Joi .number! .min 0 .max 1
      before: Joi .date! .timestamp!
      after: Joi .date! .timestamp!
  handler: handler
