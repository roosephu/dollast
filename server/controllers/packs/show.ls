require! {
  \debug
  \../../models
  \../validator
}

log = debug \dollast:ctrl:pack:show

handler = ->*
  {pack} = @params

  pack = yield models.Packs.find-by-id pack, '-__v'
    .lean!
    .exec!
  log {pack}
  @assert pack, @params.pack, \Pack, "doesn't exist"
  yield pack.permit.check-access @state.user, \r
  problems = yield models.Problems.find 'config.pack': pack._id, '_id outlook.title'
    .lean!
    .exec!
  pack.problems = problems

  @body = pack

module.exports = 
  method: \GET
  path: \/pack/:pack
  validate:
    params:
      pack: validator.pack!
  handler: handler