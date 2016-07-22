require! {
  \co
  \../models
  \../crypt
  \debug
  \koa-jwt
  \prelude-ls : {lists-to-obj}
  \../config
  \../Exception
  \node-forge
}

log = debug \dollast:ctrl:site

export theme = co.wrap (ctx) ->*
  ctx.state.user.theme = ctx.params.theme
  ctx.body = status: true

export token = co.wrap (ctx) ->*
  token = ctx.crypt.gen-salt!
  log {token}
  # ctx.state.user.token = str
  ctx.body = {token}
#
# session: ->*
#   log ctx.session
#   ctx.body = uid: if ctx.session.passport?.user?._id? then that else void

export login = co.wrap (ctx) ->*
  # ctx.check-body '_id' .len 6, 15
  # ctx.check-body 'pswd' .non-empty!
  {user, password} = ctx.request.body
  return if ctx.errors?.length > 0

  user = yield models.users.find-by-id user .exec!
  # log password, user.password
  if not user or not user.check-password password
    throw new Exception id: user._id, type: \user, detail: "bad user/password combination"

  groups = user.groups
  groups.push \users
  ctx.state.user.groups = lists-to-obj groups, [true for i from 1 to groups.length]

  client-key = ctx.request.body.client-key
  server-key = config.server-AES-key
  server-payload = JSON.stringify do
    _id: user._id
    groups: ctx.state.user.groups
    client-key: client-key
  client-payload = JSON.stringify do
    user: user._id
  payload =
    server: server-payload # crypt.AES.enc server-payload, server-key
    client: client-payload # crypt.AES.enc client-payload, client-key

  # log {payload}

  token = koa-jwt.sign payload, config.jwt-key, expires-in: 60 * 60 * 24

  refresh = koa-jwt.sign payload, config.server-AES-key, expires-in: 60 * 60 * 24 * 30
  ctx.body = {token}

export logout = co.wrap (ctx) ->*
  ...
