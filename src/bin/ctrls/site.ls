require! {
  "../db"
  "debug"
  "prelude-ls": _
  "koa-jwt"
  "../config"
}

log = debug 'dollast:ctrl:site'

export
  theme: ->*
    @session.theme = @params.theme
    @body = status: true
  login-token: ->*
    ...
    @body = @session.login-token = 1
  session: ->*
    log @session
    @body = uid: if @session.passport?.user?._id? then that else void
  login: ->*
    user = yield db.user.query @request.body
    if not user
      @body = status:
        type: "err"
        msg: "bad user/password combination"
    else
      priv-list = user.priv-list
      priv-list.push 'login'
      @session.priv = _.lists-to-obj priv-list, [true for i from 1 to priv-list.length]

      claims = _id: user._id
      token = koa-jwt.sign claims, config.secret, expires-in-seconds: 10
      @body =
        token: token
        status:
          type: "ok"
          msg: "login successfully"
  logout: ->*
    ...
