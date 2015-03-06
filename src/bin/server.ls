require! {
  'koa'
  'koa-json'
  'koa-static'
  'koa-bodyparser'
  'koa-generic-session'
  'koa-validate'
  'koa-router'
  'koa-send'
  'koa-jwt'
  'util'
  'path'
  'fs'
  'debug'
  './config'
  './db'
}

export app = koa!

log = debug 'server'

# ==== Database ====

logger.fatal "No Database found" if !db

app.use koa-bodyparser do
  extend-types:
    json: ['application/x-javascript']
    multipart: ['multipart/form-data']

# ==== Logger ====
app.use (next) ->*
  console.log "#{@req.method} #{@req.url}"
  yield next

# ==== Passport ====

app.keys = config.keys
app.use koa-generic-session do
  cookie:
    max-age: 1000 * 60 * 5

# require './auth'

# ==== JSON and Static Serving ====

app.use koa-json!
app.use (next) ->*
  db.bind-ctx @
  @session.theme ||= config.default.theme
  @session.priv  ||= config.default.priv
  if @method in ['HEAD', 'GET']
    for folders in ["public", "theme/#{@session.theme}"]
      return if yield koa-send @, @path, index: 'index.html', root: path.resolve folders
  yield next

# ========= Router ===============

routers = require './routers'

app.use koa-jwt do
  secret: config.secret
  passthrough: true

app.use (next) ->*
  log "request", @request.body, "jwt", @user, "session", @session, "query", @query
  yield next

# now begin our private router
app.use routers.router

# ====================================

console.log "Listening port 3000"
app.listen 3000
