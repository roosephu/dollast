require! {
  \co
  \koa
  \koa-compress
  \koa-json
  \koa-static
  \koa-bodyparser
  \koa-conditional-get
  \koa-validate
  \koa-mount
  \koa-convert
  \koa-send
  \koa-etag
  \koa-jwt
  \koa-webpack-middleware : {dev-middleware, hot-middleware}
  \webpack
  \path
  \debug
  \babel-polyfill
  \../webpack.config : webpack-config
  \./config
  \./crypt
  \./Exception
}

# can be used to implement a logging module
# debug.log = ->
#   console.log ...

export app = new koa!

compile = webpack webpack-config

_use = app.use
app.use = (x) ->
  _use.call app, koa-convert x

log = debug \dollast:server

# ==== Database ====

app.use koa-compress!
app.use koa-conditional-get!
app.use koa-etag!
app.use koa-json!
koa-validate app

app.use dev-middleware compile,
  no-info: true
  lazy: false
  public-path: webpack-config.output.public-path
  stats:
    colors: true

# we shouldn't compress webpack hot module replacement information
app.use (next) ->*
  # log @request.method, @request.url
  if @request.url == "/__webpack_hmr" or '/api' == @request.url.substr 0, 4
    @compress = false
  yield next

# I don't know why, but ctx.body gets modified after this middleware
app.use hot-middleware compile,
  log: debug \dollast:webpack

# ==== Session ====

app.use koa-jwt do
  secret: config.jwt-key
  passthrough: true

app.keys = config.keys
# app.use koa-generic-session do
#   cookie:
#     max-age: 1000 * 60 * 5

app.use koa-bodyparser do
  extend-types:
    json: ['application/x-javascript']
    multipart: ['multipart/form-data']

app.use co.wrap (ctx, next) ->*
  # log "server.user", ctx.state.user
  # log koa-jwt.verify ctx.request.header.authorization.substr(7), config.jwt-key, ignore-expiration: false

  # decode header
  if ctx.state?.user?.server
    #ctx.state.user = JSON.parse crypt.AES.dec that, config.server-AES-key
    if ctx.state.user.client
      client-state = JSON.parse that
      # log "client info", client-state
    else
      client-state = {}
    ctx.state.user = JSON.parse ctx.state?.user?.server
    ctx.state.user.client = client-state
    # log 'encrypted data in header.server', ctx.state.user
  else
    ctx.state.user = _id: \__guest__, groups: []

  ctx.state.user.theme ||= config.default.theme
  ctx.state.user.groups  ||= config.default.groups
  yield next!

# ==== JSON and Static Serving ====

app.use co.wrap (ctx, next) ->*
  if ctx.method in [\HEAD, \GET]
    for folder in [\public, "theme/#{ctx.state.user.theme}"]
      if yield koa-send ctx, ctx.path, index: \index.html, max-age: 864000000, root: path.resolve folder
        return
  yield next!

if process.env.NODE_ENV == \development
  app.use koa-mount \/monk, require \./monk

app.use koa-mount \/api, require \./router

app.use co.wrap (ctx, next) ->*
  ctx.body = "404!"

# ====================================

port = process.env.PORT || 3000
console.log "Listening port #{port}"
app.listen port
