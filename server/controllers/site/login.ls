require! {
  \koa-jwt
  \koa-joi-router : {Joi}
  \prelude-ls : {lists-to-obj}
  \../err : {assert-name: assert}
  \../../models
  \../../config
  \../validator
}

handler = async (ctx) ->
  # ctx.check-body '_id' .len 6, 15
  # ctx.check-body 'pswd' .non-empty!
  {user, password} = ctx.request.body
  return if ctx.errors?.length > 0

  user = await models.Users.find-by-id user .exec!
  assert \LoginError, (user and user.check-password password),
    _id: ctx.request.body.user

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

module.exports =
  method: \POST
  path: \/site/login
  validate:
    type: \json
    body:
      user: validator.user!
      password: Joi .string! .min 8 .max 16
  handler: handler
