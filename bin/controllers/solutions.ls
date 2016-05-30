require! {
  \../models
  \debug
  \../core
  \../config
}

log = debug \dollast:ctrl:sol

export submit = ->*
  @check-body \pid .is-int! .ge 1
  @check-body \language .in [\cpp, \java]
  @check-body \code .len 1, 50000
  @check-body \user .empty!
  return if @errors

  req = @request.body
  {pid} = req

  problem = yield models.problems.find-by-id pid, "permit config" .exec!
  if not problem
    throw new Error 'no problem found. '
  problem.permit.check-access @state.user, \x

  uid = @state.user.client.uid

  # @ensure-access model, 0, \x # sol = 0 => submision
  solution = new models.solutions do
    _id: yield models.solutions.next-count!
    code: req.code
    language: req.language
    problem: req.pid
    user: uid
    summary:
      status: \running
    permit: req.permit

  yield solution.save!
  core.judge req.language, req.code, problem.config, solution

  @body = status:
    type: "ok"
    msg: "solution submited successfully"

export list = ->*
  opts = config.sol-list-opts

  query = models.solutions.find {}, '-code -results'
    .populate \prob, 'outlook.title'
    .populate \round, 'title beginTime'
    .sort '-_id'
    .skip opts.skip
    .limit opts.limit
    .lean!
  if opts.uid
    query .= where \user .equals that
  if opts.pid
    query .= where \problem .equals that

  sol-list = yield query.exec!

  @body = sol-list

export show = ->*
  {sid} = @params

  solution = yield models.solutions.find-by-id sid
    .populate \problem, 'outlook.title'
    .exec!

  solution.permit.check-access @state.user, \r

  @body = solution
