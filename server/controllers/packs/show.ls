require! {
  \../../models
}

handler = ->*
  {pack} = @params

  pack = yield models.packs.find-by-id pack, '-__v'
    # .populate 'problems', '_id outlook.title'
    .lean!
    .exec!
  problems = yield models.problems.find 'config.pack': pack._id, '_id outlook.title'
    .lean!
    .exec!
  pack.problems = problems

  # if opts.mode == "view" and moment!.is-before pack.beg-time
  #   pack.probs = []
  #   pack.started = false
  # else
  #   pack.started = true

  @body = pack

module.exports = 
  method: \GET
  path: \/pack/:pack
  handler: handler