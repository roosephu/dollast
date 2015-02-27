require! {
  'koa-passport'
  'passport-local'
}

Local-strategy = passport-local.Strategy

koa-passport.serialize-user (user, done) ->
  done null, user

export init = (db) ->
  koa-passport.deserialize-user (id, done) ->
    console.log "deserialize! #{id}"
    db.user.model.find-by-id id, (err, user) ->
      done err, user
  koa-passport.use new Local-strategy (uid, pswd, done) ->
    console.log "Login: #{uid} #{pswd} #{util.inspect @session}"
    db.user.query uid, pswd, done
\
