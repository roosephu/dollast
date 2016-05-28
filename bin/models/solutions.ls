require! {
  \mongoose : {Schema}
  \debug
  \moment
  \./conn : {make-next-count, conn}
  \./permit
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
  _id: Number
  date: type: Date, default: Date.now
  code: String
  lang: String
  prob: type: Number, ref: \problem
  user: type: String, ref: \user
  round: type: Number, ref: \round
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
  permit: permit

# schema.plugin mongoose-auto-increment.plugin, model: \solution
schema.index do
  round: 1
  prob: 1
  user : 1
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

log = debug \dollast:sol

schema.statics.next-count = make-next-count 1

schema.statics.get-user-solved-problems = (uid) ->*
  # log {uid, model.aggregate}
  query = model.aggregate do
    * $match: user: uid, 'final.score': 1
    * $sort: prob: 1
    * $group:
        _id: \$prob
  return yield query.exec!

schema.statics.get-solutions-in-a-round = (rid) ->*
  query = model.aggregate do
    * $match: round: rid
    * $sort: prob: 1, user: 1, _id: -1
    * $group:
        _id:
          prob: \$prob
          user: \$user
        score:
          $first: '$final.score'
        sid:
          $first: \$_id
  return yield query.exec!

model = conn.model \solution, schema
module.exports = model
