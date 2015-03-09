require! {
  'mongoose'
  "util"
  "debug"
  "prelude-ls": _
  "./conn"
  "../core"
  "../config"
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

export model = conn.conn.model 'problem', schema
count = 0

export do
  show: (pid, opts = {}) ->*
    opts.mode ||= "view"
    fields = switch opts.mode
      | "view"    => "outlook config.timeLmt config.spaceLmt config.round"
      | "total"   => undefined
      | "brief"   => "outlook.title config.round"
      | otherwise => ...
    if opts.mode == "total"
      @acquire-privilege 'prob-all'
    prob = yield model .find-by-id pid, fields .populate "config.round", "begTime" .exec!
    if prob.config?.round?
      if not that.is-started!
        @acquire-privilege 'prob-all'
      prob .= to-object!
      prob.config.round .= _id
    else
      prob .= to-object!
    return prob

  list: (opts) ->*
    opts = config.prob-list-opts with opts
    return yield model
      .find "config.round": $exists: false, 'outlook.title stat'
      .skip opts.skip
      .limit opts.limit
      .exec!

  modify: (pid, prob) ->*
    @acquire-privilege 'prob-all'
    return yield model.update _id: pid, {$set: prob}, upsert: true, overwrite: true .exec!

  upd-data: (pid) ->*
    @acquire-privilege 'prob-all'
    prob = yield model.find-by-id pid, 'config.dataset' .exec!
    pairs = yield core.gen-data-pairs pid
    log "prob:", prob, "pairs:", pairs
    prob.config.dataset = _.map (<<< weight: 1), pairs
    yield prob.save!
  list-dataset: (pid) ->*
    @acquire-privilege 'prob-all'
    prob = yield model.find-by-id pid, "config.dataset" .lean! .exec!
    return prob.config.dataset
  next-count: ->*
    @acquire-privilege 'prob-all'
    return yield conn.next-count model, count
