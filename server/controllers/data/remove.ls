require! {
  \koa-joi-router : {Joi}
  \../../models
  \../validator
}

handler = ->*
  {pid, file} = @params

  problem = yield models.Problems.find-by-id pid, "config.dataset permit" .exec!
  @assert problem, pid, \Problem, "no such problem"
  yield problem.permit.check-access @state.user, \w

  yield core.delete-test-data pid, @params
  yield problem.rebuild!

  @body = status:
    type: "ok"
    msg: "data has been deleted"

module.exports = 
  method: \DELETE
  path: \/data/:problem/:file
  validate:
    type: \json
    params:
      problem: validator.problem!
      file: Joi .string! .required! # TODO: more limits (length, characters)
  handler: handler
