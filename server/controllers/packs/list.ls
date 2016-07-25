require! {
  \../../models
}

handler = ->*
  @body = yield models.packs.find {}, 'title beginTime endTime'
    .lean!
    .exec!

module.exports = 
  method: \GET
  path: \/pack
  handler: handler
