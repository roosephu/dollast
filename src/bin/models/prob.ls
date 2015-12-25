/*
  A `problem` may belong to some `round`.
  When we create a `round`, we must take care of these problems.
*/

require! {
  \mongoose
  \util
  \debug
  \prelude-ls : _
  \sanitize-html
  \./conn
  \../core
  \../config
  \../db
}

log = debug "dollast:prob"

schema = new mongoose.Schema do
  _id: Number
  outlook:
    desc: String
    title: String
    in-fmt: String
    out-fmt: String
    sample-in: String
    sample-out: String
  config:
    author: type: String, ref: \user
    round: type: Number, ref: "round"
    time-lmt: Number
    space-lmt: Number
    stk-lmt: Number
    out-lmt: Number
    regexp: String
    judger: String
    dataset: [
      input: String
      output: String
      weight: Number
    ]
  stat: {}

export model = conn.conn.model 'problem', schema
count = 0

export show = (pid, opts = {}) ->*
  opts.mode ||= "view"
  fields = switch opts.mode
    | "view"    => "outlook config.timeLmt config.spaceLmt config.round"
    | "total"   => undefined
    | "brief"   => "outlook.title config.round"
    | otherwise => ...
  if opts.mode == "total"
    @acquire-privilege 'prob-all'

  prob = yield model .find-by-id pid, fields
    .populate "config.round", "begTime"
    .exec!
  if not prob
    throw new Error "no such problem"

  if prob?.config?.round?
    if not that.is-started!
      @acquire-privilege 'prob-all'
    prob .= to-object!
    prob.config.round .= _id
  else
    prob .= to-object!
  return prob

export stat = (pid, opts = {}) ->*
  prob = yield model.find-by-id pid, 'config.round'
    .populate 'config.round', 'published'
    .exec!
  if not prob
    throw new Error "no such problem"

  if prob.config?.round?
    if not that.published
      @acquire-privilege 'rnd-all'

  query = db.sol.model.aggregate do
    * $match: prob: pid
    * $sort: user: 1, "final.score": -1
    * $project:
        lang: true
        final: true
        round: true
        user: true
    * $group:
        _id:
          user: "$user"
        doc:
          $first: "$$CURRENT"
        submits:
          $sum: 1

  stat = yield query .exec!
  return sols: stat

export list = (opts) ->*
  opts = config.prob-list-opts with opts
  return yield model
    .find null, 'outlook.title' # "config.round": $exists: true,
    .skip opts.skip
    .limit opts.limit
    .exec!

export upd-data = (pid) ->*
  @acquire-privilege 'prob-all'
  prob = yield model.find-by-id pid, 'config.dataset' .exec!
  pairs = yield core.gen-data-pairs pid
  prob.config.dataset = _.map (<<< weight: 1), pairs
  yield prob.save!

  return pairs

export list-dataset = (pid) ->*
  @acquire-privilege 'prob-all'
  prob = yield model.find-by-id pid, "config.dataset" .lean! .exec!
  return prob.config.dataset

func-next-count = conn.make-next-count model, count

export next-count = ->*
  log "next-count"
  @acquire-privilege 'prob-all'
  return yield func-next-count!

export modify = (pid, prob) ->*
  @acquire-privilege 'prob-all'
  if prob._id
    delete prob._id
  if pid == 0
    pid = yield next-count.bind(@)!
    log {pid}
  if prob.outlook.desc
    prob.outlook.desc |>= sanitize-html

  return yield model.update(_id: pid, {$set: prob}, upsert: true, overwrite: true).exec!
