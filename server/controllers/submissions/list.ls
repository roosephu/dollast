require! {
  \prelude-ls : {Obj}
  \debug
  \koa-joi-router : {Joi}
  \../validator
  \../../models
  \../../../common/options
}

log = debug \dollast:ctrl:submissions:list

handler = ->*
  opts = options.sol-list-opts with @request.query

  basic-filters = Obj.reject (== undefined), opts{user, pack, language}
  log {opts, basic-filters}

  query = models.Submissions.find basic-filters, '-code -results'
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
  handler: handler

