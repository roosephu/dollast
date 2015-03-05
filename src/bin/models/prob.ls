require! {
  'mongoose'
  "util"
  "debug"
  "./conn"
}

log = debug "prob-model"

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
    disabled: Boolean
  stat: {}

export model = conn.conn.model 'problem', schema
count = 0

export do
  show: (pid, opts = {}) ->*
    opts.mode ||= "view"
    fields = switch opts.mode
      | "view"    => "outlook config.timeLmt config.spaceLmt"
      | "total"   => undefined
      | otherwise => ...
    if opts.mode == "total"
      @acquire-privilege 'prob-all'
    prob = yield model .find-by-id pid, fields .lean! .exec!
    if prob.disabled
      @acquire-privilege 'prob-all'
    return prob
  list: ->*
    return yield model .find {}, 'outlook.title stat' .exec!
  modify: (pid, prob) ->*
    @acquire-privilege 'prob-all'
    return yield model.update _id: pid, {$set: prob}, upsert: true, overwrite: true .exec!
  upd-data: (pid) ->*
    @acquire-privilege 'prob-all'
    prob = yield model.find-by-id pid, 'config.dataset' .exec!
    log "prob: #{util.inspect prob}"
    pairs = yield core.gen-data-pairs pid
    prob.config.dataset = _.map (<<< weight: 1), pairs
    yield prob.save!
  list-dataset: (pid) ->*
    @acquire-privilege 'prob-all'
    prob = yield model.find-by-id pid, "config.dataset" .lean! .exec!
    return prob.config.dataset
  next-count: ->*
    @acquire-privilege 'prob-all'
    yield conn.next-count model, count
