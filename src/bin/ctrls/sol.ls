require! {
  "../db"
}

export
  submit:  ->*
    @acquire-privilege \login
    @check-body 'pid' .to-int!
    @check-body 'lang' .in ['cpp', 'java']
    @check-body 'code' .len 1, 50000
    return if @errors

    uid = @user._id
    yield db.sol.submit @request.body, uid
    @body = status:
      type: "ok"
      msg: "solution submited successfully"

  list: ->*
    @body = yield db.sol.list @query

  show: ->*
    @acquire-privilege \login
    @body = yield db.sol.show @params.sid

  toggle: ->*
    @acquire-privilege \login
    @body = yield db.sol.toggle @params.sid
    @body <<< status:
      type: "ok"
      msg: "solution toggled"
