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
  \./crypt
}

export app = koa!

log = debug 'dollast:server'

# ==== Database ====

log "No Database found" if !db

app.use koa-conditional-get!
app.use koa-etag!
app.use koa-json!
app.use koa-validate!

# ==== Session ====

app.use koa-jwt do
  secret: config.jwt-key
  passthrough: true

app.keys = config.keys
# app.use koa-generic-session do
#   cookie:
#     max-age: 1000 * 60 * 5

app.use (next) ->*
  # log @request
  yield next

app.use koa-bodyparser do
  extend-types:
    json: ['application/x-javascript']
    multipart: ['multipart/form-data']

app.use (next) ->*
  # log @request.body
  # log "server.user", @state.user
  # log koa-jwt.verify @request.header.authorization.substr(7), config.jwt-key, ignore-expiration: false

  # decode header
  if @state?.user?.server
    @state.user = JSON.parse crypt.AES.dec that, config.server-AES-key
    log 'encrypted data in header.server', @state.user
  else
    @{}state.user = {}

  content = @request.body.signed
  if content
    content = koa-jwt.decode content
    data = crypt.RSA.dec content.content
    if @state.user.user and @state.user.client-key != data.client-key
      throw new Error 'wrong client-key'

    @request.body = data
    log 'verified encrypted data found in body.', @request.body
  yield next

  # if @state.user.server
    # @body = encrypted: crypt.AES.enc JSON.stringf

# ==== Logger ====
app.use (next) ->*
  try
    log "#{@req.method} #{@req.url}"
    yield next
  catch e
    log "catched error:"
    log e
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
  # log 'current user', @state.user, config.default
  @state.user.theme ||= config.default.theme
  @state.user.priv  ||= config.default.priv
  # log @session
  if @method in ['HEAD', 'GET']
    for folders in ["public", "theme/#{@state.user.theme}"]
      if yield koa-send @, @path, index: 'index.html', max-age: 864000000, root: path.resolve folders
        return
  yield next

# ==== Jade ====
#
# app.use koa-jade.middleware do
#   view-path: "theme/dollast"
#   pretty: true
#   compile-debug: false
#
# app.use (next) ->*
#   log "hello world"
#   extname = path.extname @req.url
#   if @req.url == "/"
#     yield @render "index.html", {}, true
#   else if extname == ".html"
#     yield @render @req.url, {}, true
#   else
#     yield next

# ========= Router ===============

routers = require './routers'

app.use routers.router

# app.use (next) ->*
#   # log "request", @request.body, "jwt", @user, "query", @query
#   if not @user and config.mode != "debug"
#     throw new Error "login to explore more fields"
#   yield next

# ====================================

console.log "Listening port 8888"
app.listen 8888
