require! {
  \koa-joi-router : {Joi}
  \../validator
  \../../models
  \../../core
}

handler = ->*
  {problem, file} = @params

  problem = yield models.Problems.find-by-id problem, "config.dataset permit" .exec!
  yield @assert-exist problem, \w, @params.problem, \Problem

  yield core.delete-test-data problem._id, file
  pairs = yield problem.rebuild!

  @body = pairs

module.exports = 
  method: \DELETE
  path: \/data/:problem/:file
  validate:
    params:
      problem: validator.problem!
      file: Joi .string! .required! # TODO: more limits (length, characters)
  handler: handler
