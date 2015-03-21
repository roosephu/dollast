require! {
  'koa'
  'koa-json'
  'koa-static'
  'koa-bodyparser'
  'koa-generic-session'
  'koa-conditional-get'
  'koa-validate'
  'koa-router'
  'koa-jade'
  'koa-send'
  'koa-etag'
  'koa-jwt'
  'util'
  'path'
  'fs'
  'debug'
  'prelude-ls': _
  './config'
  './db'
}

export app = koa!

log = debug 'dollast:server'

# ==== Database ====

log "No Database found" if !db

app.use koa-conditional-get!
app.use koa-etag!
app.use koa-json!
app.use koa-validate!

app.use koa-bodyparser do
  extend-types:
    json: ['application/x-javascript']
    multipart: ['multipart/form-data']

# ==== Session ====

app.keys = config.keys
app.use koa-generic-session do
  cookie:
    max-age: 1000 * 60 * 5

# ==== Logger ====
app.use (next) ->*
  try
    log "#{@req.method} #{@req.url}"
    yield next
  catch e
    log "catched.", e
    @status = e.status || 400
    @body = [error: e.message]
  if @errors
    @status = 400
    @body = @errors

app.use (next) ->*
  @check = (obj, key, err-msg) ->
    if not obj
      if not @errors
        @errors = []
      @errors.push "#{err-msg}"
      new koa-validate.Validator @, null, null, false, null, false
    else
      new koa-validate.Validator @, key, obj[key], obj[key]?, obj
  yield next

# ==== JSON and Static Serving ====

app.use (next) ->*
  db.bind-ctx @
  @session.theme ||= config.default.theme
  @session.priv  ||= config.default.priv
  if @method in ['HEAD', 'GET']
    for folders in ["public", "theme/#{@session.theme}"]
      if yield koa-send @, @path, index: 'index.html', max-age: 864000000, root: path.resolve folders
        return
  yield next

# ==== Jade ====

app.use koa-jade.middleware do
  view-path: "theme/dollast"
  pretty: true
  compile-debug: false

app.use (next) ->*
  extname = path.extname @req.url
  if @req.url == "/"
    yield @render "index.html", {}, true
  else if extname == ".html"
    yield @render @req.url, {}, true
  else
    yield next

# ========= Router ===============

routers = require './routers'

app.use koa-jwt do
  secret: config.secret
  passthrough: true

app.use routers.pub-router

app.use (next) ->*
  log "request", @request.body, "jwt", @user, "query", @query
  if not @user and config.mode != "debug"
    throw new Error "login to explore more fields"
  yield next

# now begin our private router
app.use routers.priv-router

# ====================================

console.log "Listening port 3000"
app.listen 3000
