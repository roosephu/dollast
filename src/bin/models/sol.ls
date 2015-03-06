require! {
  "mongoose"
  "mongoose-auto-increment"
  "debug"
  "./conn"
  "../db"
  "../core"
  "../config"
}

schema = new mongoose.Schema do
  open: Boolean
  code: String
  lang: String
  prob: type: Number, ref: "problem"
  user: type: String, ref: "user"
  round: type: Number, ref: "round"
  max-time: Number
  max-space: Number
  score: Number
  results: [
    time: Number
    space: Number
    message: String
    score: Number
    status: String
    input: String
  ]
  # groups: [type: Number, ref: "group"]
schema.plugin mongoose-auto-increment.plugin, model: "solution"
model = conn.conn.model 'solution', schema
count = 0

log = debug 'sol'

export do
  submit: (req, uid) ->*
    @acquire-privilege 'login'
    sol = new model do
      code: req.code
      lang: req.lang
      prob: req.pid
      user: uid

    log "middle"
    prob = yield db.prob.model.find-by-id req.pid, 'config' .exec!
    log 'there'
    if prob.config.round
      sol.round = that
      yield prob.populate 'config.round', 'begTime' .exec-populate!
      if not prob.config.round.is-started!
        @acquire-privilege 'prob-all'

    log "here"
    yield sol.save!
    body = status: 'OK'
    core.judge req.lang, req.code, prob.config, sol

  list: (opts) ~>*
    opts = config.sol-list-opts with opts
    sol-list = yield model.find {}, '-code -results'
      .populate 'prob', 'outlook.title'
      .sort '-_id'
      .skip opts.skip
      .limit opts.limit
      .lean!
      .exec!
    return sol-list

  show: (sid) ~>*
    sol = yield model.find-by-id sid .populate 'prob', 'outlook.title' .lean! .exec!
    if not sol.open and sol.user != @get-current-user._id # todo: open other source
      @acquire-privilege 'sol-all'
    return sol

  toggle: (sid) ->*
    sol = yield model.find-by-id sid .exec!
    if sol.user != @get-current-user._id
      @acquire-privilege 'sol-all'
    != sol.open
    yield sol.save!
    return open: sol.open
