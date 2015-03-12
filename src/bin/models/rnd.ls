require! {
  "mongoose"
  "moment"
  "debug"
  "co"
  "prelude-ls": _
  "./conn"
  "../db"
}

log = debug "dollast:rnd-model"

schema = new mongoose.Schema do
  _id: Number
  title: String
  beg-time: Date
  end-time: Date
  probs: [type: Number, ref: "problem"]
  # groups: [type: Number, ref: ]

schema.methods.is-started = ->
  moment!.is-after @beg-time

schema.methods.is-ended = ->
  moment!.is-after @end-time

lock-prob = co.wrap (rid, state, probs) ->*
  log "locking", probs
  yield for pid in probs
    db.prob.model.find-by-id-and-update pid, $set: "config.round": rid .exec!

unlock-prob = co.wrap (rid, state, probs) ->*
  log "unlocking", probs
  yield for pid in probs
    db.prob.model.find-by-id-and-update pid, $unset: "config.round": rid .exec!

model = conn.conn.model 'round', schema
count = 0

export do
  modify: (rid, rnd) ~>*
    @acquire-privilege 'rnd-all'
    rnd.beg-time = new Date that if rnd.beg-time
    rnd.end-time = new Date that if rnd.end-time
    doc = yield model.find-by-id rid .exec!
    doc ||= new model

    if rnd.probs
      old-probs = if doc.probs then that else []
      new-probs = rnd.probs
      log old-probs, new-probs
      yield unlock-prob rid, false, _.difference old-probs, new-probs
      yield   lock-prob rid,  true, _.difference new-probs, old-probs

    doc <<< rnd
    yield doc.save!
    return true

  show: (rid, opts = {}) ~>*
    opts.mode ||= "view"
    if opts.mode == "total"
      @acquire-privilege 'rnd-all'

    rnd = yield model.find-by-id rid, '-__v' .populate 'probs', '_id outlook.title' .lean! .exec!
    if opts.mode == "view" and moment!.is-before rnd.beg-time
      rnd.probs = []
      rnd.started = false
    else
      rnd.started = true
    return rnd

  board: (rid, opts = {}) ->*
    log 'board...'

    query = db.sol.model.aggregate do
      * $match: round: rid
      * $sort: prob: 1, user: 1, _id: -1
      * $group:
          _id:
            prob: "$prob"
            user: "$user"
          score:
            $first: '$final.score'
          sid:
            $first: '$_id'
    results = yield query.exec!
    return results

  list: ~>*
    return yield model.find {}, 'title begTime endTime' .lean! .exec!

  delete: (rid) ~>*
    @acquire-privilege 'rnd-all'
    return yield model.find-by-id-and-remove rid .lean! .exec!

  next-count: ->*
    @acquire-privilege 'rnd-all'
    return yield conn.next-count model, count
