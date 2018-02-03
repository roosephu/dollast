require! {
  \../../models
}

handler = (ctx) ->>
  ctx.body = await models.Rounds.find {}, 'title beginTime endTime'
    .sort \_id
    .lean!
    .exec!

module.exports =
  method: \GET
  path: \/round
  handler: handler
