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
    @counter ||= 1
    while yield @model.find-by-id @counter, '_id' .lean! .exec!
      @counter += 1
      console.log "@counter"
    return @counter

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
    console.log "#{util.inspect req}"
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
      throw err if err
  list: ~>*
    return yield @model.find {}, '-code' .populate 'prob', 'outlook.title' .lean! .exec!
  show: (sid) ~>*
    return yield @model.find-by-id sid .populate 'prob', 'outlook.title' .lean! .exec!

# ==== problem ====

class prob-model extends my-model
  ->
    @schema = new mongoose.Schema do
      _id: Number
      outlook:
        desc: String
        title: String
        in-fmt: String
        out-fmt: String
        sample-in: String
        sample-out: String
      config:
        time-lmt: Number
        space-lmt: Number
        regexp: String
        inputs: [String]
        outputs: [String]
      stat: {}
      disabled: Boolean
    # @schema.plugin mongoose-auto-increment.plugin, model: "problem", start-at: 1
    @model = conn.model 'problem', @schema
  show: (pid, opts = {}) ->*
    opts.mode ||= "view"
    fields = switch opts.mode
      | "view"    => "_id outlook config.timeLmt config.spaceLmt"
      | "total"   => undefined
      | otherwise => ...
    return yield @model .find-by-id pid, fields .lean! .exec!
  list: ->*
    return yield @model .find {}, '_id outlook.title stat' .lean! .exec!
  modify: (pid, prob) ->*
    return yield @model.update _id: pid, {$set: prob}, upsert: true, overwrite: true .lean! .exec!

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
    @model = conn.model 'round', @schema
  modify: (rid, rnd) ~>*
    rnd.beg-time = new Date that if rnd.beg-time
    rnd.end-time = new Date that if rnd.end-time
    return yield @model.update _id: rid, {$set: rnd}, upsert: true, overwrite: true .lean! .exec!
  show: (rid, opts = {}) ~>*
    opts.mode ||= "view"
    rnd = yield @model.find-by-id rid .populate 'probs', '_id outlook.title' .lean! .exec!
    if opts.mode == "view" and moment!.is-before rnd.beg-time
      rnd.probs = []
      started = false
    else
      started = true
    return rnd: rnd, started: started
  list: ~>*
    return yield @model.find {}, '_id title' .lean! .exec!
  delete: (rid) ~>*
    return yield @model.find-by-id-and-remove rid .lean! .exec!

export sol = new sol-model
export prob = new prob-model
export user = new user-model
export rnd = new round-model
