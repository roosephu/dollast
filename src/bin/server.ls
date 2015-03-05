require! {
  'koa'
  'koa-json'
  'koa-static'
  'koa-bodyparser'
  'koa-generic-session'
  'koa-passport'
  'util'
  'koa-validate'
  'koa-router'
  'koa-send'
  'path'
  'fs'
  './config'
  './db'
}

app = koa!

# ==== Database ====

# config.logger = log4js.get-logger 'dollast'

logger.fatal "No Database found" if !db

app.use koa-bodyparser do
  extend-types:
    json: ['application/x-javascript']
    multipart: ['multipart/form-data']

# ==== Logger ====
app.use (next) ->*
  console.log "#{@req.method} #{@req.url} #{util.inspect @request?.header}"
  yield next

# ==== Passport ====

app.keys = config.keys
app.use koa-generic-session do
  cookie:
    max-age: 1000 * 60 * 5

require './auth'

app.use koa-passport.initialize!
app.use koa-passport.session!

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

public-router = new koa-router!

public-router
  .post '/site/login', (next) ->*
    cb = (err, user, info) ~>*
      throw that if err
      if user != false
        yield @login user
        @body = status: true
      else
        @body = status: false
    yield koa-passport.authenticate 'local', cb .call @, next
  .get '/site/logout', (next) ->*
    @logout!
    @redirect '/#/'

app.use public-router.middleware!

# require authenticated
app.use (next) ->*
  if true or @req.is-authenticated!
    # console.log "#{util.inspect(@session)}"
    yield next
  else
    @redirect '/login' # should be login

# now begin our private router
routers = require './routers'
app.use routers.private-router

# ====================================

console.log "Listening port 3000"
app.listen 3000
