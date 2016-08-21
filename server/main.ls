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

app.use koa-compress!
app.use koa-conditional-get!
app.use koa-etag!
app.use koa-json!

# ==== Session ====

app.use koa-jwt do
  secret: config.jwt.key
  passthrough: true

app.keys = config.keys

app.use (next) ->*
  if not @state?.user?
    @state.user = _id: \__guest__, groups: []
  else
    log @state.user

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

if process.env.NODE_ENV == \mock
  app.use koa-mount \/mock, require \./mock

app.use koa-mount \/api, require \./router

app.use (next) ->*
  @body = "404!"

# ====================================

port = process.env.PORT || 3000
console.log "Listening port #{port}"
app.listen port
