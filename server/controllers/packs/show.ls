require! {
  \debug
  \../../models
  \../validator
}

log = debug \dollast:ctrl:pack:show

handler = ->*
  {pack} = @params

  pack = yield models.Packs.find-by-id pack, '-__v'
    .exec!
  log {pack}
  yield @assert-exist pack, \r, @params.pack, \Pack

  problems = yield models.Problems.find 'config.pack': pack._id, '_id outlook.title'
    .sort \_id
    .lean!
    .exec!
  pack .= to-object!
  pack <<<< {problems}

  @body = pack

module.exports = 
  method: \GET
  path: \/pack/:pack
  validate:
    params:
      pack: validator.pack!
  handler: handler