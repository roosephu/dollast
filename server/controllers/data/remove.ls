require! {
  \koa-joi-router : {Joi}
  \../validator
  \../../models
  \../../core
}

handler = async (ctx) ->
  {problem, file} = ctx.params

  problem = await models.Problems.find-by-id problem, "config.dataset permit" .exec!
  await ctx.assert-exist problem, \w, ctx.params.problem, \Problem

  await core.delete-test-data problem._id, file
  pairs = await problem.rebuild!

  ctx.body = pairs

module.exports =
  method: \DELETE
  path: \/data/:problem/:file
  validate:
    params:
      problem: validator.problem!
      file: Joi .string! .required! # TODO: more limits (length, characters)
  handler: handler
