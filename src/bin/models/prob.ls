require! {
  \mongoose
  \debug
  \prelude-ls : {map}
  \sanitize-html
  \./conn
  \./permit : {schema: permit-schema}
  \../core : {gen-data-pairs}
  \../config : {prob-list-opts}
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
  permit: permit-schema

export model = conn.conn.model 'problem', schema
count = 0

export show = (pid, opts = {}) ->*
  opts.mode ||= "view"
  opts.mode = \total
  fields = switch opts.mode
    | "view"    => "outlook config.timeLmt config.spaceLmt config.round"
    | "total"   => undefined
    | "brief"   => "outlook.title config.round"
    | otherwise => ...
  if opts.mode in ["total", "view"]
    # @acquire-privilege 'prob-all'
    @ensure-access model, pid, \r

  prob = yield model .find-by-id pid, fields
    .populate "config.round", "begTime"
    .exec!
  if not prob
    throw new Error "no such problem"

  if prob?.config?.round?
    # needn't to check it since the round has settled it up
    # if not that.is-started!
      # @acquire-privilege 'prob-all'
    prob .= to-object!
    prob.config.round .= _id
  else
    prob .= to-object!
  return prob

export stat = (pid, opts = {}) ->*
  prob = yield model.find-by-id pid, 'config.round outlook.title'
    .populate 'config.round', 'published'
    .lean!
    .exec!
  if not prob
    throw new Error "no such problem"

  # log {@ensure-access, @acquire-privilege}
  @ensure-access model, pid, \r

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
  delete prob.config
  return sols: stat, prob: prob

export list = (opts) ->*
  opts = prob-list-opts with opts
  return yield model
    .find null, 'outlook.title' # "config.round": $exists: true,
    .skip opts.skip
    .limit opts.limit
    .exec!

export upd-data = (pid) ->*
  @acquire-privilege 'prob-all'
  prob = yield model.find-by-id pid, 'config.dataset' .exec!
  pairs = yield gen-data-pairs pid
  prob.config.dataset = map (<<< weight: 1), pairs
  yield prob.save!

  return pairs

export list-dataset = (pid) ->*
  @acquire-privilege 'prob-all'
  prob = yield model.find-by-id pid, "config.dataset" .lean! .exec!
  return prob.config.dataset

func-next-count = conn.make-next-count model, count

next-count = ->*
  log "next-count"
  return yield func-next-count!

export modify = (pid, prob) ->*
  @ensure-access model, pid, \w
  if prob._id
    delete prob._id
  if pid == 0
    pid = yield next-count.bind(@)!
    log {pid}
  if prob.outlook.desc
    prob.outlook.desc |>= sanitize-html

  return yield model.update(_id: pid, {$set: prob}, upsert: true, overwrite: true).exec!
