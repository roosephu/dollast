require! {
  \debug
  \../../models
  \../validator
}

log = debug \dollast:ctrl:pack:show

handler = async (ctx) ->
  {pack} = ctx.params

  pack = await models.Packs.find-by-id pack, '-__v'
    .exec!
  log {pack}
  await ctx.assert-exist pack, \r, ctx.params.pack, \Pack

  problems = await models.Problems.find 'config.pack': pack._id, '_id outlook.title'
    .sort \_id
    .lean!
    .exec!
  pack .= to-object!
  pack <<<< {problems}

  ctx.body = pack

module.exports =
  method: \GET
  path: \/pack/:pack
  validate:
    params:
      pack: validator.pack!
  handler: handler
