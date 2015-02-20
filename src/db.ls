require! {
  'mongoose'
  'mongoose-deep-populate'
  'mongoose-auto-increment'
  'log4js'
  'util'
}

logger = log4js.get-logger 'dollast'
ObjectID = mongoose.Schema.Types.ObjectID

export conn = mongoose.create-connection 'mongodb://localhost/dollast'
mongoose-auto-increment.initialize conn
mongoose.plugin mongoose-deep-populate

# ==== solution model ====
class sol-model
  ->
    @schema = new mongoose.Schema(
      code: String
      time: Number
      space: Number
      lang: String
      result: String
      prob:
        type: Number
        ref: "problem"
      user:
        type: String
        ref: "user"
    )
    @schema.plugin mongoose-auto-increment.plugin
    @model = conn.model 'solution', @schema
  submit: (req, uid) ~>*
    logger.trace "submit problem #{util.inspect req}"
    res = runner.run req.lang, req.code
    sol = new @model(
      code: req.code
      time: res.time
      space: res.space
      lang: req.lang
      prob: req.pid
      user: uid
      result: res.result
    )
    sol.save (err, sol) ->
      return if err
      logger.trace "Current solution: #{util.inspect sol}"
  list: ~>*
    sols = yield @model.find {}, '-code' .populate 'prob', 'title stat' .exec!
    return sols
  show: (sid) ~>*
    sol = yield @model.find-by-id sid .populate 'prob', 'title' .exec!
    return sol

# ==== problem ====

class prob-model
  ->
    @model = conn.model 'problem',
      _id: Number
      desc: String
      title: String
      time-lmt: Number
      space-lmt: Number
      sample-in: String
      sample-out: String
      stat: {}
  show: (pid) ->*
    logger.trace "query problem #{pid}"
    prob = yield @model .find-by-id pid .exec!
    return prob
  list: ->*
    probs = yield @model .find {}, 'id title stat' .exec!
    return probs

# ==== user ====

class user-model
  ~>
    @model = conn.model 'user',
      _id: String
      pswd: String
  query: (uid, pswd, done) ~>
    @model.find-by-id uid, (err, user) ->
      if err
        done err
      else if !user or user.pswd != pswd
        console.log 'No such user'
        done null, false
      else
        console.log 'authenticate OK'
        done null, user

export sol = new sol-model
export prob = new prob-model
export user = new user-model!
