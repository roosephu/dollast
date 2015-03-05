require! {
  'koa-passport'
  'passport-local'
  "debug"
  "util"
  "prelude-ls": _
  "co"
  "./db"
}

log = debug "auth"

Local-strategy = passport-local.Strategy

koa-passport.serialize-user (user, done) ->*
  log "user #{util.inspect user} done"
  {priv-list} = yield db.user.model.find-by-id user.user, "priv-list"
  priv-list.push 'login'
  # priv-list = _.map _.capitalize, priv-list
  user.priv-list = _.pairs-to-obj priv-list, [true for i from 1 to priv-list.length]
  done null, user

koa-passport.deserialize-user (id, done) ->
  console.log "deserialize! #{id}"
  db.user.model.find-by-id id, (err, user) ->
    done err, user
koa-passport.use new Local-strategy (uid, pswd, done) ->
  console.log "Login: #{uid} #{pswd} #{util.inspect @}"
  db.user.query uid, pswd, done
