require! {
  \debug
  \../../models
  \../validator
}

log = debug \dollast:ctrl:problems:show

handler = async (ctx) ->
  log "finding problem"
  {problem} = ctx.params

  problem = await models.Problems.find-by-id problem
    .populate 'config.round', \title
    .exec!
  await ctx.assert-exist problem, \r, ctx.params.problem, \Problem

  # TODO check whether the corresponding round has started
  problem .= to-object!
  ctx.body = problem

module.exports =
  method: \GET
  path: \/problem/:problem
  validate:
    params:
      problem: validator.problem!
  handler: handler
