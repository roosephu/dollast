require! {
  \mongoose : {Schema}
  \debug
  \moment
  \./conn : {make-next-count, conn}
  \./permit
  \../config
}

atom-result-schema = new Schema do
  _id: false
  time: Number
  space: Number
  message: String
  score: Number
  status: String
  input: String
  output: String
  weight: Number

schema = new Schema do
  _id: String
  date: type: Date, default: Date.now
  code: String
  language: String
  problem: type: Number, ref: \problem
  user: type: String, ref: \user
  round: type: Number, ref: \round
  summary:
    time: Number
    space: Number
    message: String
    score: Number
    status: String
    input: String
    output: String
    weight: Number
  results: [atom-result-schema]
  permit: permit

# schema.plugin mongoose-auto-increment.plugin, model: \solution
schema.index do
  round: 1
  problem: 1
  user : 1
  _id: -1
schema.index do
  problem: 1
  user: 1
  "summary.score": -1
schema.index do
  user: 1
  problem: 1
  round: 1
  "summary.score": -1

log = debug \dollast:sol

schema.statics.next-count = make-next-count config.starting-ids.solutions

schema.statics.get-user-solved-problems = (uid) ->*
  # log {uid, model.aggregate}
  query = model.aggregate do
    * $match: user: uid, 'summary.score': 1
    * $sort: problem: 1
    * $group:
        _id: \$problem
  return yield query.exec!

schema.statics.get-solutions-in-a-round = (rid) ->*
  query = model.aggregate do
    * $match: round: rid
    * $sort: problem: 1, user: 1, _id: -1
    * $group:
        _id:
          problem: \$problem
          user: \$user
        score:
          $first: '$summary.score'
        sid:
          $first: \$_id
  return yield query.exec!

model = conn.model \solution, schema
module.exports = model
