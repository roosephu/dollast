require! {
  \co
  \koa
  \koa-compress
  \koa-json
  \koa-conditional-get
  \koa-mount
  \koa-send
  \koa-etag
  \koa-jwt
  \stream : {PassThrough}
  \webpack-dev-middleware
  \webpack-hot-middleware
  \webpack
  \path
  \debug
  \babel-polyfill
  \../build/webpack.dev.config : webpack-dev-config
  \./config
  \./crypt
}

# can be used to implement a logging module
# debug.log = ->
#   console.log ...

export app = new koa!

log = debug \dollast:server

# ==== Database ====

app.use koa-compress!
app.use koa-conditional-get!
app.use koa-etag!
app.use koa-json!

# ==== Webpack Middleware ====

# we shouldn't compress webpack hot module replacement information
app.use (next) ->*
  # log @request.method, @request.url
  if @request.url == "/__webpack_hmr" or '/api' == @request.url.substr 0, 4
    @compress = false
  yield next

if process.env.NODE_ENV == \development

  compiler = webpack webpack-dev-config
  express-dev-middleware = webpack-dev-middleware compiler, 
    no-info: true
    lazy: false
    public-path: webpack-dev-config.output.public-path
    stats:
      colors: true
  express-hot-middleware = webpack-hot-middleware compiler,
    log: debug \dollast:webpack

  app.use (next) ->*
    promise = express-dev-middleware @req, 
      end: (content) ~>
        @body = content
      set-header: @set.bind @
      co.wrap ->*
        yield next
    yield that if promise

  app.use (next) ->*
    stream = new PassThrough!
    @body = stream
    promise = express-hot-middleware @req,
      write: stream.write.bind stream
      write-head: (state, headers) ~>
        @state = state
        @set headers
      co.wrap ->*
        yield next
    yield that if promise 

# ==== Session ====

app.use koa-jwt do
  secret: config.jwt-key
  passthrough: true

app.keys = config.keys
# app.use koa-generic-session do
#   cookie:
#     max-age: 1000 * 60 * 5

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

  @state.user.theme ||= config.default.theme
  @state.user.groups  ||= config.default.groups
  yield next

# ==== JSON and Static Serving ====

app.use (next) ->*
  if @method in [\HEAD, \GET]
    for folder in [\public, "theme/#{@state.user.theme}"]
      if yield koa-send @, @path, index: \index.html, max-age: 864000000, root: path.resolve folder
        return
  yield next

if process.env.NODE_ENV == \development
  app.use koa-mount \/monk, require \./monk

app.use koa-mount \/api, require \./router

app.use (next) ->*
  @body = "404!"

# ====================================

port = process.env.PORT || 3000
console.log "Listening port #{port}"
app.listen port
