require! {
  \../../models
}

handler = async (ctx) ->
  ctx.body = await models.Packs.find {}, 'title beginTime endTime'
    .sort \_id
    .lean!
    .exec!

module.exports =
  method: \GET
  path: \/pack
  handler: handler
