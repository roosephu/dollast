require! {
  \../../models
}

handler = ->*
  {pack} = @params

  pack = yield models.packs.find-by-id pack, \permit .exec!
  if not pack
    throw new Error "no such packs"
  pack.permit.check-access @state.user, \r

  @body = yield models.submissions.get-submissions-in-a-pack rid

module.exports = 
  method: \GET
  path: \/pack/:pack/board
  handler: handler