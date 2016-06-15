require! {
  \koa
  \koa-compress
  \koa-json
  \koa-static
  \koa-bodyparser
  # 'koa-generic-session'
  \koa-conditional-get
  \koa-validate
  # 'koa-jade'
  \koa-send
  \koa-etag
  \koa-jwt
  \path
  \debug
  \./config
  \./models
  \./crypt
  \./Exception
}

export app = koa!

log = debug \dollast:server

# ==== Database ====

log "No Database found" if !models

app.use koa-compress!
app.use koa-conditional-get!
app.use koa-etag!
app.use koa-json!
koa-validate app

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
  # log "server.user", @state.user
  # log koa-jwt.verify @request.header.authorization.substr(7), config.jwt-key, ignore-expiration: false

  # decode header
  if @state?.user?.server
    #@state.user = JSON.parse crypt.AES.dec that, config.server-AES-key
    if @state.user.client
      client-state = JSON.parse that
      # log "client info", client-state
    else
      client-state = {}
    @state.user = JSON.parse @state?.user?.server
    @state.user.client = client-state
    # log 'encrypted data in header.server', @state.user
  else
    @state.user = _id: \__guest__, groups: []

  # log 'user state', @state.user

  #content = @request.body.signed
  #if content
    #content = koa-jwt.decode content
    #data = crypt.RSA.dec content.content
    #if @state.user.user and @state.user.client-key != data.client-key
      #throw new Error 'wrong client-key'
#
    #@request.body = data
    #log 'verified encrypted data found in body.', @request.body
  yield next

  # if @state.user.server
    # @body = encrypted: crypt.AES.enc JSON.stringf

app.use (next) ->*
  @check = (obj, key, err-msg) ->
    return true
  #   if not obj
  #     if not @errors
  #       @errors = []
  #     @errors.push "#{err-msg}"
  #     new koa-validate.Validator @, null, null, false, null, false
  #   else
  #     new koa-validate.Validator @, key, obj[key], obj[key]?, obj
  yield next

# ==== JSON and Static Serving ====

app.use (next) ->*
  # log 'current user', @state.user, config.default
  @state.user.theme ||= config.default.theme
  @state.user.groups  ||= config.default.groups
  # log @session
  if @method in [\HEAD, \GET]
    for folders in [\public, "theme/#{@state.user.theme}"]
      if yield koa-send @, @path, index: \index.html, max-age: 864000000, root: path.resolve folders
        return
  yield next

# ==== Logger ====
app.use (next) ->*
  @errors = []
  @throw = (err) ->
    throw new Exception err
  @check-errors = ->
    if @errors.length > 0
      throw new Exception
  @assert = (expression, e) ->
    if !expression
      throw new Exception e

  try
    log 'request body', @request.body
    log "#{@req.method} #{@req.url}"
    yield next
  catch e
    if e instanceof Exception
      if e.error
        @errors.push e.error
    else
      @app.emit \error, e, @

  @status = 200
  if @errors.length > 0
    @body = errors: @errors
  else
    @body = data: @body

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

routers = require \./routers

app.use routers.router

# app.use (next) ->*
#   # log "request", @request.body, "jwt", @user, "query", @query
#   if not @user and config.mode != "debug"
#     throw new Error "login to explore more fields"
#   yield next

# ====================================

port = process.env.PORT || 3000
console.log "Listening port #{port}"
app.listen port
