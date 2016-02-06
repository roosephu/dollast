require! {
  "../db"
  "../crypt"
  "debug"
  "koa-jwt"
  "prelude-ls": _
  "../config"
  \node-forge
}

log = debug 'dollast:ctrl:site'

export
  theme: ->*
    @state.user.theme = @params.theme
    @body = status: true

  token: ->*
    token = @crypt.gen-salt!
    log {token}
    # @state.user.token = str
    @body = {token}
  #
  # session: ->*
  #   log @session
  #   @body = uid: if @session.passport?.user?._id? then that else void

  login: ->*
    # @check-body '_id' .len 6, 15
    # @check-body 'pswd' .non-empty!
    post = @request.body
    pswd = post.pswd
    return if @errors

    user = yield db.user.query post.uid, pswd
    if not user
      @body = status:
        type: "err"
        msg: "bad user/password combination"
    else
      groups = user.groups
      groups.push 'login'
      @state.user.priv = _.lists-to-obj groups, [true for i from 1 to groups.length]

      client-key = @request.body.client-key
      server-key = config.server-AES-key
      server-payload = JSON.stringify do
        uid: user._id
        priv: @state.user.priv
        client-key: client-key
      client-payload = JSON.stringify do
        uid: user._id
      payload =
        server: server-payload # crypt.AES.enc server-payload, server-key
        client: client-payload # crypt.AES.enc client-payload, client-key

      token = koa-jwt.sign payload, config.jwt-key, expires-in-seconds: 60 * 60 * 24

      refresh = koa-jwt.sign payload, config.server-AES-key, expires-in-seconds: 60 * 60 * 24 * 30
      @body =
        type: "ok"
        payload:
          {token}
  logout: ->*
    ...
