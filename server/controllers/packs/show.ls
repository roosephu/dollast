require! {
  \../../models
  \../validator
}

handler = ->*
  {pack} = @params

  pack = yield models.packs.find-by-id pack, '-__v'
    .lean!
    .exec!
  problems = yield models.problems.find 'config.pack': pack._id, '_id outlook.title'
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