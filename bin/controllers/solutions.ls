require! {
  \../db
  \debug
  \../core
  \../config
}

log = debug \dollast:ctrl:sol

export submit = ->*
  @check-body \pid .is-int! .ge 1
  @check-body \lang .in [\cpp, \java]
  @check-body \code .len 1, 50000
  @check-body \user .empty!
  return if @errors

  req = @request.body
  {pid} = req

  problem = yield db.problems.find-by-id pid, "permit config" .exec!
  if not problem
    throw new Error 'no problem found. '
  problem.permit.check-access @state.user, \x

  uid = @state.user.client.uid

  # @ensure-access model, 0, \x # sol = 0 => submision
  solution = new db.solutions do
    _id: yield db.solutions.next-count!
    code: req.code
    lang: req.lang
    prob: req.pid
    user: uid
    final:
      status: \running
    permit: req.permit

  yield solution.save!
  core.judge req.lang, req.code, problem.config, solution

  @body = status:
    type: "ok"
    msg: "solution submited successfully"

export list = ->*
  opts = config.sol-list-opts

  query = db.solutions.find {}, '-code -results'
    .populate \prob, 'outlook.title'
    .populate \round, 'title begTime'
    .sort '-_id'
    .skip opts.skip
    .limit opts.limit
    .lean!
  if opts.uid
    query .= where \user .equals that
  if opts.pid
    query .= where \prob .equals that

  sol-list = yield query.exec!

  @body = sol-list

export show = ->*
  {sid} = @params

  solution = yield db.solutions.find-by-id sid
    .populate 'prob', 'outlook.title'
    .exec!

  solution.permit.check-access @state.user, \r

  @body = solution
