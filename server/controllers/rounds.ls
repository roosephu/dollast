require! {
  \co
  \flat
  \debug
  \../models
}

log = debug \dollast:ctrl:round

export list = co.wrap (ctx) ->*
  ctx.body = yield models.rounds.find null, 'title beginTime endTime'
    .lean!
    .exec!

export show = co.wrap (ctx) ->*
  {rid} = ctx.params

  round = yield models.rounds.find-by-id rid, '-__v'
    .populate 'problems', '_id outlook.title'
    .lean!
    .exec!

  # if opts.mode == "view" and moment!.is-before rnd.beg-time
  #   rnd.probs = []
  #   rnd.started = false
  # else
  #   rnd.started = true

  ctx.body = round

export save = co.wrap (ctx) ->*
  {rid} = ctx.params
  round = ctx.request.body

  if round._id
    delete round._id

  if rid == "0"
    rid = yield models.rounds.next-count!
    round._id = rid
    log {rid}
  else
    existed = yield models.rounds.find-by-id rid, \permit .exec!
    if not existed
      ctx.body =
        status:
          type: \error
          message: "cannot find the original round"
      return
    existed.permit.check-access ctx.state.user, \w

    # TODO: check permit is not modified here
    # only owner can transfer owner

    # flat it!
    round |>= flat

  ctx.body = yield models.rounds.update _id: rid, round, upsert: true .exec!

  ctx.body =
    _id: rid
    detail: "round saved"

export remove = co.wrap (ctx) ->*
  {rid} = ctx.params

  round = yield models.rounds.find-by-id rid, \permit .exec!
  round.permit.check-access ctx.state.user, \w

  round.remove!

  ctx.body = status:
    type: "ok"
    msg: "round has been deleted"

export board = co.wrap (ctx) ->*
  {rid} = ctx.params

  round = yield models.rounds.find-by-id rid, \permit .exec!
  if not round
    throw new Error "no such rounds"
    return
  round.permit.check-access ctx.state.user, \r

  ctx.body = yield models.submissions.get-submissions-in-a-round rid
