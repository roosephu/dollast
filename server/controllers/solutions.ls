require! {
  \co
  \../models
  \debug
  \../core
  \../config
}

log = debug \dollast:ctrl:sol

export submit = co.wrap (ctx) ->*
  ctx.check-body \pid .is-int! .ge 1
  ctx.check-body \language .in [\cpp, \java]
  ctx.check-body \code .len 1, 50000
  ctx.check-body \user .empty!
  return if ctx.errors

  req = ctx.request.body
  {pid} = req

  problem = yield models.problems.find-by-id pid, "permit config" .exec!
  ctx.assert problem, id: pid, type: \problem, detail: 'no problem found. '
  problem.permit.check-access ctx.state.user, \x

  uid = ctx.state.user.client.uid

  # ctx.ensure-access model, 0, \x # sol = 0 => submision
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

  ctx.body = msg: "solution submited successfully"

export list = co.wrap (ctx) ->*
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

  ctx.body = sol-list

export show = co.wrap (ctx) ->*
  {sid} = ctx.params

  solution = yield models.solutions.find-by-id sid
    .populate \problem, 'outlook.title'
    .exec!
  ctx.assert solution, id: sid, type: \solution, detail: 'no solution found. '

  solution.permit.check-access ctx.state.user, \r

  ctx.body = solution
