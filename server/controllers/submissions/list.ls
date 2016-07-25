require! {
  \prelude-ls : {Obj}
  \debug
  \../../config : {sol-list-opts}
  \../../models
}

log = debug \dollast:ctrl:submissions:list

handler = ->*
  # TODO: verify input
  opts = sol-list-opts with @request.query

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

module.exports = 
  method: \GET
  path: \/submission
  handler: handler

