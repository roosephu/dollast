require! {
  \debug
  \../../models
  \../validator
}

log = debug \dollast:ctrl:round:show

handler = async (ctx) ->
  {round} = ctx.params

  round = await models.Rounds.find-by-id round, '-__v'
    .exec!
  log {round}
  await ctx.assert-exist round, \r, ctx.params.round, \Round

  problems = await models.Problems.find 'config.round': round._id, '_id outlook.title'
    .sort \_id
    .lean!
    .exec!
  round .= to-object!
  round <<<< {problems}

  ctx.body = round

module.exports =
  method: \GET
  path: \/round/:round
  validate:
    params:
      round: validator.round!
  handler: handler
