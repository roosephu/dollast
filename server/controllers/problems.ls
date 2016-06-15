require! {
  \../models
  \debug
  \../config : {prob-list-opts}
  \sanitize-html
}

log = debug \dollast:ctrls:prob

export list = ->*
  opts = prob-list-opts
  @body = yield models.problems
    .find null, \outlook.title # "config.round": $exists: true,
    .skip opts.skip
    .limit opts.limit
    .exec!
  # log "prob-list #{@body}"

export show = ->*
  log "finding problem"
  {pid} = @params

  problem = yield models.problems.find-by-id pid
    # .populate "config.round", "begTime"
    .exec!
  if not problem
    @throw do
      _id: pid
      type: \problem
      detail: "non-existing problem"
  problem.permit.check-access @state.user, \r

  # TODO check whether the corresponding round has started
  problem .= to-object!
  @body = problem

export save = ->*
  {pid} = @params

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
  @check-body \/config/judger, true .get! .in [\string, \strict, \real, \custom]
  @check-body \/permit/owner, true .get!
  # return if @errors.length > 0
  @check-errors!

  problem = @request.body

  if problem._id
    delete problem._id
  if pid == void
    pid = yield models.problems.next-count!
    log "saving new problem using id #{pid}"

    # TODO: check whether user can create a problem here
  else
    existed = yield models.problems.find-by-id pid, \permit .exec!
    @assert existed, id: pid, type: \problem, detail: "cannot find the original problem"

    existed.permit.check-access @state.user, \w

    # TODO: check permit is not modified here
    # only owner can transfer owner

  yield models.problems.update _id: pid, problem, upsert: true, overwrite: true .exec!
  @body = problem with _id: pid

export remove = ->*
  # TODO: implement removing a problem
  ...

export stat = ->*
  {pid} = @params

  problem = yield models.problems.find-by-id pid, 'config.round outlook.title permit'
    .exec!
  if not problem
    throw new Error "no such problem"
  problem.permit.check-access @state.user, \r

  query = models.solutions.aggregate do
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

  solutions = yield query.exec!
  delete problem.config
  delete problem.permit

  @body = sols: solutions, prob: problem
