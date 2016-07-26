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

  problem = yield models.problems.find-by-id problem, "permit config" 
    .populate 'config.pack', 'title' 
    .exec!
  @assert problem, problem._id, \Problem, "problem doesn't exist"
  problem.check-access @state.user, \x

  pack = problem.config.pack._id
  {user} = @state.user.client

  # @ensure-access model, 0, \x # sol = 0 => submission
  submission = new models.submissions do
    _id: yield models.submissions.next-count!
    code: code
    language: language
    problem: problem._id
    user: user
    pack: pack
    summary:
      status: \running
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
      user: validator.user!
      problem: validator.problem!
      pack: validator.pack!
      permit: validator.permit!
    continue-on-error: false
  handler: handler