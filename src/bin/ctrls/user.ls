require! {
  "../db"
  "../salt"
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
    # @check-body '_id' .len 6, 15
    # @check-body 'pswd' .len 8, 15
    uid = @request.body.uid
    pswd = salt.unsalt @request.body.pswd, @

    @body = yield db.user.register _id: uid, pswd: pswd

  profile: ->*
    @body = yield db.user.profile @params.uid
