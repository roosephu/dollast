require! {
  \../../models
  \../validator
  \../error
}

handler = ->*
  {pack} = @params

  pack = yield models.packs.find-by-id pack, \permit .exec!
  if not pack
    throw new error @params.pack, \Pack, "no such packs"
  pack.check-access @state.user, \r

  @body = yield models.submissions.get-submissions-in-a-pack rid

module.exports = 
  method: \GET
  path: \/pack/:pack/board
  validate:
    params:
      pack: validator.pack!
  handler: handler