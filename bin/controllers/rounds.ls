require! {
  \../db
  \debug
}

log = debug \dollast:ctrl:round

export list = ->*
  @body = yield db.rounds.find null, 'title begTime endTime'
    .lean!
    .exec!

export show = ->*
  {rid} = @params

  round = yield db.rounds.find-by-id rid, '-__v'
    .populate 'probs', '_id outlook.title'
    .lean!
    .exec!

  # if opts.mode == "view" and moment!.is-before rnd.beg-time
  #   rnd.probs = []
  #   rnd.started = false
  # else
  #   rnd.started = true

  @body = round

export save = ->*
  {rid} = @params
  round = @request.body

  if round._id
    delete round._id

  if rid == 0
    rid = yield db.rounds.next-count!
    round._id = rid
    log {rid}
  else
    existed = yield db.rounds.find-by-id rid, \permit .exec!
    if not existed
      @body =
        status:
          type: \error
          message: "cannot find the original round"
      return
    existed.permit.check-access @state.user, \w

    # TODO: check permit is not modified here
    # only owner can transfer owner

  @body = yield db.rounds.update _id: rid, round, upsert: true, overwrite: true .exec!

  @body <<< status:
    type: "ok"
    msg: "round saved"

export remove = ->*
  {rid} = @params

  round = yield db.rounds.find-by-id rid, \permit .exec!
  round.permit.check-access @state.user, \w

  round.remove!

  @body = status:
    type: "ok"
    msg: "round has been deleted"

export board = ->*
  {rid} = @params

  round = yield db.rounds.find-by-id rid, \permit .exec!
  if not round
    throw new Error "no such rounds"
    return
  round.permit.check-access @state.user, \r

  @body = yield db.solutions.get-solutions-in-a-round rid
