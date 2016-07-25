require! {
  \co
  \debug
  \sanitize-html
  \flat
  \../../common/judgers
  \../models
  \../config : {prob-list-opts}
}

log = debug \dollast:ctrls:prob

export list = ->*
  opts = prob-list-opts
  @body = yield models.problems
    .find null, \outlook.title # "config.pack": $exists: true,
    .skip opts.skip
    .limit opts.limit
    .exec!
  # log \problem-list, @body

export show = ->*
  log "finding problem"
  {problem} = @params

  problem = yield models.problems.find-by-id problem
    .populate 'config.pack', \title
    .exec!
  if not problem
    @throw do
      _id: problem._id
      type: \problem
      detail: "non-existing problem"
  problem.permit.check-access @state.user, \r

  # TODO check whether the corresponding pack has started
  problem .= to-object!
  @body = problem

export save = ->*

  #@check-body 'method' .in ['modify', 'create'], 'wrong method'
  # log req.outlook.title
  @check-body \/outlook/title, true .get! .len 1, 63
  # @check req.outlook, 'title' .len 1, 63
  #@check req.outlook, 'inFmt' .not-empty!
  #@check req.outlook, 'outFmt' .not-empty!
  #@check req.outlook, 'sampleIn' .not-empty!
  #@check req.outlook, 'sampleOut' .not-empty!
  @check-body \/config/timeLimit, true .get! .is-float! .gt 0
  @check-body \/config/spaceLimit, true .get! .is-float! .gt 0
  @check-body \/config/stackLimit, true .get! .is-float! .gt 0
  @check-body \/config/outputLimit, true .get! .is-float! .gt 0
  @check-body \/config/judger, true .get! .in Object.keys judgers
  @check-body \/permit/owner, true .get!
  return if @errors?.length > 0

  problem = @request.body

  if problem._id == void
    problem._id = yield models.problems.next-count!
    log "saving new problem using id #{problem._id}"

    # TODO: check whether user can create a problem here
  else

    existed = yield models.problems.find-by-id problem._id, \permit .exec!
    @assert existed, id: problem._id, type: \problem, detail: "cannot find the original problem"

    existed.permit.check-access @state.user, \w

    # TODO: check permit is not modified here
    # only owner can transfer owner

    # we are updating!
    problem |>= flat
    log {problem}

  yield models.problems.update _id: problem._id, problem, upsert: true .exec!
  @body = problem

export remove = ->*
  # TODO: implement removing a problem
  ...

export stat = ->*
  {problem} = @params

  problem = yield models.problems.find-by-id problem, 'config.pack outlook.title permit'
    .exec!
  if not problem
    throw new Error "no such problem"
  problem.permit.check-access @state.user, \r

  query = models.submissions.aggregate do
    * $match: problem: problem._id
    * $sort: user: 1, "final.score": -1
    * $project:
        language: true
        summary: true
        pack: true
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

  @body = {submissions, problem}
