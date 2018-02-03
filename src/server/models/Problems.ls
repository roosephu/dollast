require! {
  \mongoose : {Schema}
  \debug
  \prelude-ls : {map}
  \../core : {gen-data-pairs}
  \./conn
  \./permit
  \../config
}

log = debug \dollast:problem

schema = new Schema do
  _id: type: String, required: true
  outlook:
    description: String
    title: String
    input-format: String
    output-format: String
    sample-input: String
    sample-output: String
  config:
    date: type: Date, default: Date.now
    round: type: String, ref: \round
    time-limit: Number
    space-limit: Number
    stack-limit: Number
    output-limit: Number
    regexp: String
    judger: String
    dataset: [
      input: String
      output: String
      weight: Number
    ]
  statistics: {}
  permit: permit

schema.index do
  round: 1

schema.statics.get-problems-by-user = (user) ->*
  yield model.find 'permit.owner': user, '_id outlook.title' .exec!

schema.methods.rebuild = ->*
  pairs = yield gen-data-pairs @_id
  @config.dataset = map (<<< weight: 1), pairs
  yield @save!

  return pairs

schema.methods.get-display-name = -> \Problem

schema.statics.get-problems-by-round = (round) ->*
  yield model.find 'config.round': round .exec!

schema.statics.next-count = conn.make-next-count config.starting-ids.problems

model = conn.conn.model \problem, schema
module.exports = model
