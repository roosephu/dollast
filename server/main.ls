require! {
  \co
  \koa
  \koa-compress
  \koa-json
  \koa-convert
  \koa-conditional-get
  \koa-mount
  \koa-send
  \koa-etag
  \koa-jwt
  \path
  \debug
  \./config
  \./crypt
}

# can be used to implement a logging module
# debug.log = ->
#   console.log ...

export app = new koa!

log = debug \dollast:server

# ==== Database ====

app.use koa-convert koa-compress!
app.use koa-convert koa-conditional-get!
app.use koa-convert koa-etag!
app.use koa-convert koa-json!

# app.use (next) ->*
#   # log @request.method, @request.url
#   if '/api' == @request.url.substr 0, 4
#     @compress = false
#   yield next

# ==== Session ====

app.use koa-convert koa-jwt do
  secret: config.jwt-key
  passthrough: true

app.keys = config.keys
# app.use koa-generic-session do
#   cookie:
#     max-age: 1000 * 60 * 5

app.use (ctx, next) ->>
  # log "server.user", @state.user
  # log koa-jwt.verify @request.header.authorization.substr(7), config.jwt-key, ignore-expiration: false

  # decode header
  if ctx.state?.user?.server
    #@state.user = JSON.parse crypt.AES.dec that, config.server-AES-key
    if ctx.state.user.client
      client-state = JSON.parse that
      # log "client info", client-state
    else
      client-state = {}
    ctx.state.user = JSON.parse ctx.state?.user?.server
    ctx.state.user.client = client-state
    # log 'encrypted data in header.server', @state.user
  else
    ctx.state.user = _id: \__guest__, groups: []

  ctx.state.user.theme ||= config.default.theme
  ctx.state.user.groups  ||= config.default.groups
  await next!

# ==== JSON and Static Serving ====

app.use (ctx, next) ->>
  if ctx.method in [\HEAD, \GET]
    for folder in [\public, "theme/#{ctx.state.user.theme}"]
      if await koa-send ctx, ctx.path, index: \index.html, max-age: 864000000, root: path.resolve folder
        return
  await next!

if process.env.NODE_ENV == \mock
  app.use koa-mount \/mock, require \./mock

app.use koa-mount \/api, require \./router

app.use (ctx, next) ->>
    ctx.body = "404!"

# ====================================

port = process.env.PORT || 3000
console.log "Listening port #{port}"
app.listen port
