require! {
  \debug
  \../../models
  \../validator
}

log = debug \dollast:ctrl:problem:remove

handler = (ctx) ->>
  {problem} = ctx.params

  problem = await models.Problems.find-by-id problem, \permit .exec!
  await ctx.assert-exist problem, \w, ctx.params.problem, \Problem

  await models.Problems.find-by-id-and-remove problem._id .exec!

  ctx.body =
    data:
      message: "deleting done"

module.exports =
  method: \DELETE
  path: \/problem/:problem
  validate:
    params:
      problem: validator.problem!
  handler: handler
