require! {
  "mongoose"
  "./conn"
  "debug"
}

log = debug "user-model"

schema = new mongoose.Schema do
  _id: String
  pswd: String
  priv-list: [String]
model = conn.conn.model 'user', schema

export do
  query: (uid, pswd, salt, done) ~>
    model.find-by-id uid, (err, user) ->
      if err
        done err
      else if !user or user.pswd != pswd
        console.log 'No such user'
        done null, false
      else
        console.log 'authenticate OK'
        done null, user
  show: (uid) ->*
    log "uid: #uid"
    return yield model.find-by-id uid, "privList" .exec!
  modify: (user) ->*
    return yield model.update _id: user._id, {$set: user}, upsert: true, overwrite: true .exec!
  register: (user) ->*
    user.priv-list = ['']
    user = new model user
    yield user.save!
    return "OK"
