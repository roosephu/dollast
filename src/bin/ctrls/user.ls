require! {
  "../db"
  "../salt"
  "../config"
  "debug"
}

log = debug 'dollast:ctrl:user'

export
  save: ->*
    # @acquire-privilege \login
    @check-body '_id' .len config.uid-min-len, config.uid-max-len
    delete @request.body.pswd # should check once here
    return if @errors

    yield db.user.modify @request.body
    @body = status:
      type: "ok"
      msg: "user profile saved"

  register: ->*
    # @check-body '_id' .len 6, 15
    # @check-body 'pswd' .len 8, 15
    uid = @request.body.uid

    @body = yield db.user.register _id: uid, pswd: @request.body.pswd

  profile: ->*
    @body = yield db.user.profile @params.uid

  get-privileges: ->*
    @body = yield db.user.get-privileges @params.uid
