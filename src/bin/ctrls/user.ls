require! {
  "../db"
  "debug"
}

log = debug 'dollast:ctrl:user'

export
  save: ->*
    @check-body '_id' .len 6, 15
    delete @request.body.pswd
    return if @errors

    yield db.user.modify @request.body
    @body = status:
      type: "ok"
      msg: "user profile saved"
  register: ->*
    @check-body '_id' .len 6, 15
    @check-body 'pswd' .len 8, 15
    return if @errors

    yield db.user.register @request.body
    @body = status:
      type: "ok"
      msg: "registering successfully"

  profile: ->*
    @body = yield db.user.profile @params.uid
