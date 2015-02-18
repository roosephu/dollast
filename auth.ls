require! 'koa-passport'
require! 'passport-local'
require! 'mongoose'

Local-strategy = passport-local.Strategy

koa-passport.serialize-user (user, done) ->
  done null, user
koa-passport.deserialize-user (id, done) ->
  db.user.model.find-by-id id, (err, user) ->
    done err, user

koa-passport.use new Local-strategy (uid, pswd, done) ->
  console.log "Login: #{uid} #{pswd}"
  db.user.query uid, pswd, done
