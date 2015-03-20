require! {
  "../db"
  "../salt"
  "debug"
  "koa-jwt"
  "prelude-ls": _
  "../config"
}

log = debug 'dollast:ctrl:site'

export
  theme: ->*
    @session.theme = @params.theme
    @body = status: true

  token: ->*
    str = salt.gen-salt!
    @session.salt = str
    @body = salt: str

  session: ->*
    log @session
    @body = uid: if @session.passport?.user?._id? then that else void

  login: ->*
    # @check-body '_id' .len 6, 15
    # @check-body 'pswd' .non-empty!
    post = @request.body
    pswd = salt.unsalt post.pswd, @
    return if @errors

    user = yield db.user.query post._id, pswd
    if not user
      @body = status:
        type: "err"
        msg: "bad user/password combination"
    else
      priv-list = user.priv-list
      priv-list.push 'login'
      @session.priv = _.lists-to-obj priv-list, [true for i from 1 to priv-list.length]

      claims = _id: user._id, priv: @session.priv
      token = koa-jwt.sign claims, config.secret, expires-in-seconds: 10
      @body =
        token: token
        status:
          type: "ok"
          msg: "login successfully"
  logout: ->*
    ...
