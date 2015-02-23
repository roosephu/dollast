require! {
  'mongoose'
  'mongoose-deep-populate'
  'mongoose-auto-increment'
  'log4js'
  'util'
  'prelude-ls': _
  'moment'
}

logger = log4js.get-logger 'dollast'
ObjectID = mongoose.Schema.Types.ObjectID

export conn = mongoose.create-connection 'mongodb://localhost/dollast'
mongoose-auto-increment.initialize conn
mongoose.plugin mongoose-deep-populate

class my-model
  next-count: ~>*
    promise = new mongoose.Promise!
    @model.next-count (err, count) ->
      if err
        promose.reject err
      else
        promise.complete count
    return yield promise

# ==== solution model ====
class sol-model extends my-model
  ->
    @schema = new mongoose.Schema do
      code: String
      time: Number
      space: Number
      lang: String
      result: Number
      prob: type: Number, ref: "problem"
      user: type: String, ref: "user"
      round: type: Number, ref: "round"
      # groups: [type: Number, ref: "group"]
    @schema.plugin mongoose-auto-increment.plugin, model: "solution"
    @model = conn.model 'solution', @schema
  submit: (req, uid) ~>*
    res = runner.run req.lang, req.code
    sol = new @model do
      code: req.code
      time: res.time
      space: res.space
      lang: req.lang
      prob: req.pid
      user: uid
      result: res.result
    sol.save (err, sol) ->
      return if err
  list: ~>*
    return yield @model.find {}, '-code' .populate 'prob', 'title stat' .exec!
  show: (sid) ~>*
    return yield @model.find-by-id sid .populate 'prob', 'title' .exec!

# ==== problem ====

class prob-model extends my-model
  ->
    @schema = new mongoose.Schema do
      _id: Number
      desc: String
      title: String
      in-fmt: String
      out-fmt: String
      time-lmt: Number
      space-lmt: Number
      sample-in: String
      sample-out: String
      stat: {}
      disabled: Boolean
    @schema.plugin mongoose-auto-increment.plugin, model: "problem"
    @model = conn.model 'problem', @schema
  show: (pid) ->*
    logger.trace "query problem #{pid}"
    return yield @model .find-by-id pid .exec!
  list: ->*
    return yield @model .find {}, 'id title stat' .exec!
  modify: (pid, prob) ->*
    return yield @model.update _id: pid, {$set: prob}, upsert: true, overwrite: true .exec!

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

class round-model extends my-model
  ~>
    @schema = new mongoose.Schema do
      _id: Number
      title: String
      beg-time: Date
      end-time: Date
      probs: [type: Number, ref: "problem"]
      # groups: [type: Number, ref: ]
    @schema.plugin mongoose-auto-increment.plugin, model: 'round', start-at: 1
    @model = conn.model 'round', @schema
  modify: (rid, rnd) ~>*
    rnd.beg-time = new Date that if rnd.beg-time
    rnd.end-time = new Date that if rnd.end-time
    return yield @model.update _id: rid, {$set: rnd}, upsert: true, overwrite: true .exec!
  show: (rid, forced = false) ~>*
    rnd = yield @model.find-by-id rid .populate 'probs', '_id title' .exec!
    if not forced and moment!.is-before rnd.beg-time
      rnd.probs = []
      started = false
    else
      started = true
    return rnd: rnd, started: started
  list: ~>*
    return yield @model.find {}, '_id title' .exec!
  delete: (rid) ~>*
    return yield @model.find-by-id-and-remove rid .exec!

export sol = new sol-model
export prob = new prob-model
export user = new user-model
export rnd = new round-model
