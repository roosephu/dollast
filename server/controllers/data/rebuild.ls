require! {
  \../validator
  \../../models
}

handler = async (ctx) ->
  {problem} = ctx.params

  problem = await models.Problems.find-by-id problem, "config.dataset permit" .exec!
  await ctx.assert-exist problem, \w, ctx.params.problem, \Problem

  new-pairs = await problem.rebuild!
  ctx.body = new-pairs

module.exports =
  method: \GET
  path: \/data/:problem/rebuild
  validate:
    params:
      problem: validator .problem!
  handler: handler
