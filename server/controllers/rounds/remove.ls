require! {
  \../../models
  \../validator
}

handler = async (ctx) ->
  {round} = ctx.params

  round = await models.Rounds.find-by-id round, \permit .exec!
  await ctx.assert-exist round, \w, ctx.params.round, \Round

  await models.Rounds.find-by-id-and-remove round._id .exec!

  ctx.body =
    _id: round._id
    type: \round
    detail: "round has been deleted"

module.exports =
  method: \DELETE
  path: \/round/:round
  validate:
    params:
      round: validator.round!
  handler: handler
