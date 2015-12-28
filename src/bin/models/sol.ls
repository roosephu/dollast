require! {
  \mongoose
  \mongoose-auto-increment
  \debug
  \moment
  \./conn
  \./permit : {schema: permit-schema}
  \../db
  \../core
  \../config
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
  permit: permit-schema

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
schema.index do
  user: 1
  prob: 1
  round: 1
  "final.score": -1

export model = conn.conn.model 'solution', schema
count = 0

log = debug 'dollast:sol'

export submit = (req, uid) ->*
  @ensure-access model, 0, \x # sol = 0 => submision
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

export list = (opts) ~>*
  new-opts = {}
  new-opts <<<< config.sol-list-opts
  new-opts <<<< opts
  opts = new-opts

  query = model.find {}, '-code -results'
    .populate 'prob', 'outlook.title'
    .populate 'round', 'title begTime'
    .sort '-_id'
    .skip opts.skip
    .limit opts.limit
    .lean!
  if opts.uid
    query .= where 'user' .equals that
  if opts.pid
    query .= where 'prob' .equals that

  sol-list = yield query.exec!

  user = @get-current-user!
  log "user", user
  if 'unpub-rnd-sol' not in user.priv
    current-time = moment!
    for sol in sol-list
      if sol.round and current-time.is-before sol.round.beg-time
        sol.final = status: "hidden"
        sol.prob = _id: 0

  return sol-list

export show = (sid, opts = {}) ~>*
  @ensure-access model, sid, \r
  sol = yield model.find-by-id sid
    .populate 'prob', 'outlook.title'
    .populate 'round', 'published'
    .lean! .exec!

  if sol.round?.published? and (not sol.round?.published and 'unpub-rnd-sol' not in @get-current-user!.priv)
    sol.final = status: "private"
    delete sol.results
  return sol

export toggle = (sid) ->*
  @ensure-access model, sid, \w
  sol = yield model.find-by-id sid .exec!

  # todo: change permission here
  yield sol.save!
  return open: sol.open
