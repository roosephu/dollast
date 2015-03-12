require! {
  "mongoose"
  "mongoose-auto-increment"
  "debug"
  "./conn"
  "../db"
  "../core"
  "../config"
}

atom-result-schema = new mongoose.Schema do
  _id: false
  time: Number
  space: Number
  message: String
  score: Number
  status: String
  input: String
  output: String
  weight: Number

schema = new mongoose.Schema do
  open: Boolean
  code: String
  lang: String
  prob: type: Number, ref: "problem"
  user: type: String, ref: "user"
  round: type: Number, ref: "round"
  final:
    time: Number
    space: Number
    message: String
    score: Number
    status: String
    input: String
    output: String
    weight: Number
  results: [atom-result-schema]
  # groups: [type: Number, ref: "group"]

schema.plugin mongoose-auto-increment.plugin, model: "solution"
schema.index do
  round: 1
  prob: 1
  user: 1
  _id: -1
schema.index do
  prob: 1
  user: 1
  "final.score": -1

export model = conn.conn.model 'solution', schema
count = 0

log = debug 'dollast:sol'

export do
  submit: (req, uid) ->*
    @acquire-privilege 'login'
    sol = new model do
      code: req.code
      lang: req.lang
      prob: req.pid
      user: uid
      final:
        status: "running"

    prob = yield db.prob.model.find-by-id req.pid, 'config' .exec!
    if not prob
      throw new Error 'no problem found. '
    if prob.config.round
      sol.round = that
      yield prob.populate 'config.round', 'begTime' .exec-populate!
      if not prob.config.round.is-started!
        @acquire-privilege 'prob-all'

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
      .lean! .exec!
    return sol-list

  show: (sid) ~>*
    log sid
    sol = yield model.find-by-id sid
      .populate 'prob', 'outlook.title'
      .lean! .exec!
    if not sol.open and sol.user != @get-current-user!._id # todo: open other source
      log sol.user, @get-current-user!
      @acquire-privilege 'sol-all'
    return sol

  toggle: (sid) ->*
    sol = yield model.find-by-id sid .exec!
    if sol.user != @get-current-user._id
      @acquire-privilege 'sol-all'
    != sol.open
    yield sol.save!
    return open: sol.open
