require! {
  "../db"
  "../core"
}

export
  upload: ->*
    pid = @params.pid
    parts = co-busboy @, auto-fields: true
    while part = yield parts
      @body = yield core.upload pid, part
    yield db.prob.upd-data pid
    @body <<< status:
      type: "ok"
      msg: "upload successful"
  delete: ->* # validate
    pid = @params.pid
    yield core.delete-test-data pid, @params.file
    @body = status:
      type: "ok"
      msg: "data has been deleted"
  show: ->*
    data = yield db.prob.list-dataset @params.pid
    @body = data
