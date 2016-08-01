require! {
  \../../models
  \../validator
}

handler = ->*
  {pack} = @params

  pack = yield models.Packs.find-by-id pack, \permit .exec!
  @assert pack, @params.pack, \Pack, "no such packs"
  yield pack.permit.check-access @state.user, \r

  @body = yield models.Submissions.get-submissions-in-a-pack pack._id

module.exports = 
  method: \GET
  path: \/pack/:pack/board
  validate:
    params:
      pack: validator.pack!
  handler: handler