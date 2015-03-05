require! {
  "mongoose"
  "moment"
  "debug"
  "./conn"
}

log = debug "rnd-model"

schema = new mongoose.Schema do
  _id: Number
  title: String
  beg-time: Date
  end-time: Date
  probs: [type: Number, ref: "problem"]
  # groups: [type: Number, ref: ]
model = conn.conn.model 'round', schema

export do
  modify: (rid, rnd) ~>*
    @acquire-privilege 'rnd-all'
    rnd.beg-time = new Date that if rnd.beg-time
    rnd.end-time = new Date that if rnd.end-time
    return yield model.update _id: rid, {$set: rnd}, upsert: true, overwrite: true .exec!
  show: (rid, opts = {}) ~>*
    opts.mode ||= "view"
    if opts.mode == "total"
      @acquire-privilege 'rnd-all'

    rnd = yield model.find-by-id rid .populate 'probs', '_id outlook.title' .lean! .exec!
    if opts.mode == "view" and moment!.is-before rnd.beg-time
      rnd.probs = []
      started = false
    else
      started = true
    return rnd: rnd, started: started
  list: ~>*
    return yield model.find {}, '_id title' .lean! .exec!
  delete: (rid) ~>*
    @acquire-privilege 'rnd-all'
    return yield model.find-by-id-and-remove rid .lean! .exec!
