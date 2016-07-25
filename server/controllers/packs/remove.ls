require! {
  \../../models
}

handler = ->*
  {pack} = @params

  pack = yield models.packs.find-by-id pack, \permit .exec!
  pack.permit.check-access @state.user, \w

  yield models.packs.find-by-id-and-remove pack._id .exec!

  @body = status:
    type: "ok"
    msg: "pack has been deleted"

module.exports =
  method: \DELETE
  path: \/pack/:pack
  handler: handler