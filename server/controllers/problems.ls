require! {
  \co
  \debug
  \sanitize-html
  \../models
  \../config : {prob-list-opts}
}

log = debug \dollast:ctrls:prob

export list = co.wrap (ctx) ->*
  opts = prob-list-opts
  ctx.body = yield models.problems
    .find null, \outlook.title # "config.round": $exists: true,
    .skip opts.skip
    .limit opts.limit
    .exec!
  # log \problem-list, ctx.body

export show = co.wrap (ctx) ->*
  log "finding problem"
  {pid} = ctx.params

  problem = yield models.problems.find-by-id pid
    # .populate "config.round", "begTime"
    .exec!
  if not problem
    ctx.throw do
      _id: pid
      type: \problem
      detail: "non-existing problem"
  problem.permit.check-access ctx.state.user, \r

  # TODO check whether the corresponding round has started
  problem .= to-object!
  ctx.body = problem

export save = co.wrap (ctx) ->*
  {pid} = ctx.params

  #ctx.check-body 'method' .in ['modify', 'create'], 'wrong method'
  # log req.outlook.title
  ctx.check-body \/outlook/title, true .get! .len 1, 63
  # ctx.check req.outlook, 'title' .len 1, 63
  #ctx.check req.outlook, 'inFmt' .not-empty!
  #ctx.check req.outlook, 'outFmt' .not-empty!
  #ctx.check req.outlook, 'sampleIn' .not-empty!
  #ctx.check req.outlook, 'sampleOut' .not-empty!
  ctx.check-body \/config/timeLimit, true .get! .is-float! .gt 0
  ctx.check-body \/config/spaceLimit, true .get! .is-float! .gt 0
  ctx.check-body \/config/stackLimit, true .get! .is-float! .gt 0
  ctx.check-body \/config/outputLimit, true .get! .is-float! .gt 0
  ctx.check-body \/config/judger, true .get! .in [\string, \strict, \real, \custom]
  ctx.check-body \/permit/owner, true .get!
  return if ctx.errors?.length > 0

  problem = ctx.request.body

  if problem._id
    delete problem._id
  if pid == void
    pid = yield models.problems.next-count!
    log "saving new problem using id #{pid}"

    # TODO: check whether user can create a problem here
  else
    existed = yield models.problems.find-by-id pid, \permit .exec!
    ctx.assert existed, id: pid, type: \problem, detail: "cannot find the original problem"

    existed.permit.check-access ctx.state.user, \w

    # TODO: check permit is not modified here
    # only owner can transfer owner

  yield models.problems.update _id: pid, problem, upsert: true, overwrite: true .exec!
  ctx.body = problem with _id: pid

export remove = co.wrap (ctx) ->*
  # TODO: implement removing a problem
  ...

export stat = co.wrap (ctx) ->*
  {pid} = ctx.params

  problem = yield models.problems.find-by-id pid, 'config.round outlook.title permit'
    .exec!
  if not problem
    throw new Error "no such problem"
  problem.permit.check-access ctx.state.user, \r

  query = models.submissions.aggregate do
    * $match: problem: pid
    * $sort: user: 1, "final.score": -1
    * $project:
        language: true
        summary: true
        round: true
        user: true
    * $group:
        _id:
          user: "$user"
        doc:
          $first: "$$CURRENT"
        submits:
          $sum: 1

  submissions = yield query.exec!
  delete problem.config
  delete problem.permit

  ctx.body = {submissions, problem}
