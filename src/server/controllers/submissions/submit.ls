require! {
  \koa-joi-router : {Joi}
  \debug
  \../validator
  \../../core
  \../../models
}

log = debug \dollast:ctrl:submissions:submit

handler = (ctx) ->>
  log \submitting
  {problem, code, language, permit} = ctx.request.body

  problem = await models.Problems.find-by-id problem, "permit config"
    .populate 'config.round', 'finished'
    .exec!
  await ctx.assert-exist problem, \x, problem._id, \Problem

  round = problem.config.round._id
  hidden = round.finished
  {user} = ctx.state.user.client

  # ctx.ensure-access model, 0, \x # sol = 0 => submission
  submission = new models.Submissions do
    _id: await models.Submissions.next-count!
    code: code
    language: language
    problem: problem._id
    user: user
    round: round
    hidden: round
    summary:
      status: \running
      score: 0
    permit: permit

  await submission.save!
  core.judge language, code, problem.config, submission

  ctx.body = msg: "submission submited successfully"

module.exports =
  method: \POST
  path: \/submission
  validate:
    type: \json
    body:
      language: Joi .string! .required! .valid [\java, \cpp]
      code: Joi .string! .required! .min 0 .max 50000
      problem: validator.problem!
      permit: validator.permit!
  handler: handler
