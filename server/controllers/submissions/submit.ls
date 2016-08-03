require! {
  \koa-joi-router : {Joi}
  \debug
  \../validator
  \../../core
  \../../models
}

log = debug \dollast:ctrl:submissions:submit

handler = ->*
  log \submitting
  {problem, code, language, permit} = @request.body

  problem = yield models.Problems.find-by-id problem, "permit config" 
    .populate 'config.pack', 'title' 
    .exec!
  @assert problem, problem._id, \Problem, "problem doesn't exist"
  yield problem.permit.check-access @state.user, \x

  pack = problem.config.pack._id
  {user} = @state.user.client

  # @ensure-access model, 0, \x # sol = 0 => submission
  submission = new models.Submissions do
    _id: yield models.Submissions.next-count!
    code: code
    language: language
    problem: problem._id
    user: user
    pack: pack
    summary:
      status: \running
      score: 0
    permit: permit

  yield submission.save!
  core.judge language, code, problem.config, submission

  @body = msg: "submission submited successfully"

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