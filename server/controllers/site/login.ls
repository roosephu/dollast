require! {
  \koa-jwt
  \koa-joi-router : {Joi}
  \prelude-ls : {lists-to-obj}
  \../../models
  \../../config
  \../validator
}

handler = ->*
  # @check-body '_id' .len 6, 15
  # @check-body 'pswd' .non-empty!
  {user, password} = @request.body
  return if @errors?.length > 0

  user = yield models.Users.find-by-id user .exec!
  @assert (user and user.check-password password), @request.body.user, \User, "bad user/password combination", \password

  groups = user.groups
  groups.push \users
  @state.user.groups = lists-to-obj groups, [true for i from 1 to groups.length]

  client-key = @request.body.client-key
  server-key = config.server-AES-key
  server-payload = JSON.stringify do
    _id: user._id
    groups: @state.user.groups
    client-key: client-key
  client-payload = JSON.stringify do
    user: user._id
  payload =
    server: server-payload # crypt.AES.enc server-payload, server-key
    client: client-payload # crypt.AES.enc client-payload, client-key

  # log {payload}

  token = koa-jwt.sign payload, config.jwt-key, expires-in: 60 * 60 * 24

  refresh = koa-jwt.sign payload, config.server-AES-key, expires-in: 60 * 60 * 24 * 30
  @body = {token}

module.exports = 
  method: \POST
  path: \/site/login
  validate:
    type: \json
    body:
      user: validator.user!
      password: Joi .string! .min 8 .max 16
  handler: handler