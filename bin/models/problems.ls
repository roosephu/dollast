require! {
  \mongoose : {Schema}
  \debug
  \prelude-ls : {map}
  \../core : {gen-data-pairs}
  \./conn
  \./permit
}

log = debug \dollast:prob

schema = new Schema do
  _id: type: Number, required: true
  outlook:
    desc: String
    title: String
    in-fmt: String
    out-fmt: String
    sample-in: String
    sample-out: String
  config:
    date: type: Date, default: Date.now
    round: type: Number, ref: \round
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
  permit: permit

schema.statics.get-user-owned-problems = (uid) ->*
  return yield model.find 'permit.owner': uid, '_id outlook.title' .exec!

schema.methods.repair = ->*
  pairs = yield gen-data-pairs @_id
  @config.dataset = map (<<< weight: 1), pairs
  yield @save!

  return pairs

schema.statics.next-count = conn.make-next-count 1

model = conn.conn.model \problem, schema
module.exports = model
