require! {
  \koa-joi-router : {Joi}
  \../../models
  \../validator
}

handler = ->*
  {pid, file} = @params

  problem = yield models.problems.find-by-id pid, "config.dataset permit" .exec!
  if not problem
    throw new Exception "xxx"
  problem.permit.check-access @state.user, \w

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
