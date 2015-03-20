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
  query: (uid, pswd) ->*
    usr = yield model.find-by-id uid .exec!
    if not usr or not usr.check-password pswd
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
    old = yield model.find-by-id user._id, '_id' .lean! .exec!
    if old
      log "here", old
      return status:
          type: 'err'
          msg: "duplicate user id"
    user.priv-list = []
    user = new model user
    user.pswd = bcrypt.hash-sync user.pswd, config.bcrypt-cost
    yield user.save!

    return status:
      type: "ok"
      msg: "register successful"

  profile: (uid) ->*
    user = yield model.find-by-id uid, '-pswd' .lean! .exec!
    return user

# CSRF
