require! {
  \../../models
  \../validator
}

handler = ->*
  {pack} = @params

  pack = yield models.packs.find-by-id pack, \permit .exec!
  @assert pack, @params.pack, \Pack, "doesn't exist"
  pack.permit.check-access @state.user, \w

  yield models.packs.find-by-id-and-remove pack._id .exec!

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