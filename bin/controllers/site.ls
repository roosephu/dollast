require! {
  \../models
  \../crypt
  \debug
  \koa-jwt
  \prelude-ls : {lists-to-obj}
  \../config
  \node-forge
}

log = debug \dollast:ctrl:site

export theme = ->*
  @state.user.theme = @params.theme
  @body = status: true

export token = ->*
  token = @crypt.gen-salt!
  log {token}
  # @state.user.token = str
  @body = {token}
#
# session: ->*
#   log @session
#   @body = uid: if @session.passport?.user?._id? then that else void

export login = ->*
  # @check-body '_id' .len 6, 15
  # @check-body 'pswd' .non-empty!
  {uid, password} = @request.body
  return if @errors

  user = yield models.users.find-by-id uid .exec!
  if not user.check-password password
    @body = status:
      type: \err
      msg: "bad user/password combination"
  else
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
      uid: user._id
    payload =
      server: server-payload # crypt.AES.enc server-payload, server-key
      client: client-payload # crypt.AES.enc client-payload, client-key

    # log {payload}

    token = koa-jwt.sign payload, config.jwt-key, expires-in: 60 * 60 * 24

    refresh = koa-jwt.sign payload, config.server-AES-key, expires-in: 60 * 60 * 24 * 30
    @body =
      type: "ok"
      payload:
        {token}

export logout = ->*
  ...
