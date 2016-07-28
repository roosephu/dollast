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
  problem: type: String, ref: \problem
  user: type: String, ref: \user
  pack: type: String, ref: \pack
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

# schema.plugin mongoose-auto-increment.plugin, model: \submission
schema.index do
  pack: 1
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
  pack: 1
  "summary.score": -1
schema.index do
  date: -1

log = debug \dollast:sol

schema.statics.next-count = make-next-count config.starting-ids.submissions

schema.methods.get-display-name = -> \Submission

schema.statics.get-user-solved-problem-ids = (user) ->*
  # log {user, model.aggregate}
  query = model.aggregate do
    * $match: user: user, 'summary.score': 1
    * $sort: problem: 1
    * $group:
        _id: \$problem
    
  return yield query.exec!

schema.statics.get-submissions-in-a-pack = (pack) ->*
  query = model.aggregate do
    * $match: pack: pack
    * $sort: problem: 1, user: 1, _id: -1
    * $group:
        _id:
          problem: \$problem
          user: \$user
        score:
          $first: '$summary.score'
        solution:
          $first: \$_id
  return yield query.exec!

model = conn.model \submission, schema
module.exports = model
