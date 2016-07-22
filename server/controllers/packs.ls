require! {
  \co
  \flat
  \debug
  \../models
}

log = debug \dollast:ctrl:pack

export list = co.wrap (ctx) ->*
  ctx.body = yield models.packs.find null, 'title beginTime endTime'
    .lean!
    .exec!

export show = co.wrap (ctx) ->*
  {pack} = ctx.params

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

  ctx.body = pack

export save = co.wrap (ctx) ->*
  # TODO: validation
  pack = ctx.request.body

  if pack._id == void
    pack._id = yield models.packs.next-count!
    # throw new Error "pack must have its id"
  else
    existed = yield models.packs.find-by-id pack._id, \permit .exec!
    if not existed
      ctx.body =
        status:
          type: \error
          message: "cannot find the original pack"
      return
    existed.permit.check-access ctx.state.user, \w

    # TODO: check permit is not modified here
    # only owner can transfer owner

    # flat it!
    pack |>= flat

  ctx.body = yield models.packs.update _id: pack._id, pack, upsert: true .exec!

  ctx.body =
    _id: pack._id
    detail: "pack saved"

export remove = co.wrap (ctx) ->*
  {pack} = ctx.params

  pack = yield models.packs.find-by-id pack, \permit .exec!
  pack.permit.check-access ctx.state.user, \w

  pack.remove!

  ctx.body = status:
    type: "ok"
    msg: "pack has been deleted"

export board = co.wrap (ctx) ->*
  {pack} = ctx.params

  pack = yield models.packs.find-by-id pack, \permit .exec!
  if not pack
    throw new Error "no such packs"
    return
  pack.permit.check-access ctx.state.user, \r

  ctx.body = yield models.submissions.get-submissions-in-a-pack rid
