require! {
  "mongoose"
  "debug"
  "bcrypt"
  "./conn"
  "../config"
}

log = debug "user-model"

schema = new mongoose.Schema do
  _id: String
  pswd: String
  priv-list: [String]

schema.methods.check-password = (candidate) ->
  return bcrypt.compare-sync @pswd, candidate

model = conn.conn.model 'user', schema

export do
  query: (uid, pswd, done) ->*
    usr = yield model.find-by-id uid .exec!

    , (err, user) ->
      if err
        done err
      else if !user or user.pswd != pswd
        done null, false
      else
        done null, user
  show: (uid) ->*
    @acquire-privilege 'user-all'
    log "uid: #uid"
    return yield model.find-by-id uid, "privList" .exec!
  modify: (user) ->*
    if user._id != @get-current-user._id
      @acquire-privilege 'user-all'
    return yield model.update _id: user._id, {$set: user}, upsert: true, overwrite: true .exec!
  register: (user) ->*
    user.priv-list = ['']
    user = new model user
    yield user.save!
    return "OK"

# CSRF
