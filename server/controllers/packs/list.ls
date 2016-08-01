require! {
  \../../models
}

handler = ->*
  @body = yield models.Packs.find {}, 'title beginTime endTime'
    .lean!
    .exec!

module.exports = 
  method: \GET
  path: \/pack
  handler: handler
