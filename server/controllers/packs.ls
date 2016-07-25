require! {
  \co
  \flat
  \debug
  \../models
}

log = debug \dollast:ctrl:pack

export list = ->*
  @body = yield models.packs.find null, 'title beginTime endTime'
    .lean!
    .exec!

export show = ->*
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

export save = ->*
  # TODO: validation
  pack = @request.body
  log {pack}

  if pack._id == void
    pack._id = yield models.packs.next-count!
    # throw new Error "pack must have its id"
  else
    existed = yield models.packs.find-by-id pack._id, \permit .exec!
    if not existed
      @body =
        status:
          type: \error
          message: "cannot find the original pack"
      return
    existed.permit.check-access @state.user, \w

    # TODO: check permit is not modified here
    # only owner can transfer owner

    # flat it!
    pack |>= flat

  @body = yield models.packs.update _id: pack._id, pack, upsert: true .exec!

  @body =
    _id: pack._id
    detail: "pack saved"

export remove = ->*
  {pack} = @params

  pack = yield models.packs.find-by-id pack, \permit .exec!
  pack.permit.check-access @state.user, \w

  yield models.packs.find-by-id-and-remove pack._id .exec!

  @body = status:
    type: "ok"
    msg: "pack has been deleted"

export board = ->*
  {pack} = @params

  pack = yield models.packs.find-by-id pack, \permit .exec!
  if not pack
    throw new Error "no such packs"
  pack.permit.check-access @state.user, \r

  @body = yield models.submissions.get-submissions-in-a-pack rid
