require! {
  \../../models
  \../validator
}

handler = ->*
  {pack} = @params

  pack = yield models.Packs.find-by-id pack, \permit .exec!
  yield @assert-exist pack, \w, @params.pack, \Pack

  yield models.Packs.find-by-id-and-remove pack._id .exec!

  @body = 
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