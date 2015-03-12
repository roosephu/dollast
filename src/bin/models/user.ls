require! {
  "mongoose"
  "debug"
  "bcrypt"
  "./conn"
  "../config"
}

log = debug "dollast:user"

schema = new mongoose.Schema do
  _id: String
  pswd: String
  desc: String
  priv-list: [String]

schema.methods.check-password = (candidate) ->
  return bcrypt.compare-sync candidate, @pswd

model = conn.conn.model 'user', schema

export do
  query: (user) ->*
    usr = yield model.find-by-id user._id .exec!
    if not usr or not usr.check-password user.pswd
      return null
    return usr
  show: (uid) ->*
    log "uid: #uid", @get-current-user!
    if uid != @get-current-user!._id
      @acquire-privilege 'user-all'
    return yield model.find-by-id uid, "privList" .exec!
  modify: (user) ->*
    if user._id != @get-current-user!._id
      @acquire-privilege 'user-all'
    return yield model.update _id: user._id, {$set: user}, upsert: true, overwrite: true .exec!
  register: (user) ->*
    user.priv-list = []
    user = new model user
    user.pswd = bcrypt.hash-sync user.pswd, config.bcrypt-cost
    yield user.save!
    return "OK"
  profile: (uid) ->*
    user = yield model.find-by-id uid, '-pswd' .exec!
    return user

# CSRF
