require! {
  \../../models
  \../validator
}

handler = async (ctx) ->
  {pack} = ctx.params

  pack = await models.Packs.find-by-id pack, \permit .exec!
  await ctx.assert-exist pack, \w, ctx.params.pack, \Pack

  await models.Packs.find-by-id-and-remove pack._id .exec!

  ctx.body =
    _id: pack._id
    type: \pack
    detail: "pack has been deleted"

module.exports =
  method: \DELETE
  path: \/pack/:pack
  validate:
    params:
      pack: validator.pack!
  handler: handler
