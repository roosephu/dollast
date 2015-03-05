require! {
  "mongoose"
  "mongoose-auto-increment"
  "./conn"
  "./../core"
}

schema = new mongoose.Schema do
  code: String
  lang: String
  prob: type: Number, ref: "problem"
  user: type: String, ref: "user"
  round: type: Number, ref: "round"
  max-time: Number
  max-space: Number
  score: Number
  results: [
    time: Number
    space: Number
    message: String
    score: Number
    status: String
    input: String
  ]
  # groups: [type: Number, ref: "group"]
schema.plugin mongoose-auto-increment.plugin, model: "solution"
model = conn.conn.model 'solution', schema
count = 0

export do
  submit: (req, uid) ->*
    sol = new model do
      code: req.code
      lang: req.lang
      prob: req.pid
      user: uid
    yield sol.save!
    yield sol.populate 'prob', 'config' .exec-populate!
    body = status: 'OK'
    core.judge req.lang, req.code, sol.prob.config, sol
  list: ~>*
    return yield model.find {}, '-code -results' .populate 'prob', 'outlook.title' .lean! .exec!
  show: (sid) ~>*
    return yield model.find-by-id sid .populate 'prob', 'outlook.title' .lean! .exec!
  next-count: conn.next-count model, count
