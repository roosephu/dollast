require! {
  "../db"
  \debug
}

log = debug \dollast:ctrl:round

export
  list: ->*
    @body = yield db.rnd.list!

  next-count: ->*
    @acquire-privilege \login
    @body = _id: yield db.rnd.next-count!

  show: ->*
    @body = yield db.rnd.show @params.rid, mode: "view"

  save: ->*
    @acquire-privilege \login
    # log {body: @request.body}
    yield db.rnd.modify @params.rid, @request.body
    @body = status:
      type: "ok"
      msg: "round saved"

  total: ->*
    @acquire-privilege \login
    @body = yield db.rnd.show @params.rid, mode: "total"

  remove: ->*
    @acquire-privilege \login
    yield db.rnd.delete @params.rid
    @body = status:
      type: "ok"
      msg: "round has been deleted"

  board: ->*
    rid = @params.rid
    @body = yield db.rnd.board rid

  publish: ->*
    @acquire-privilege \login
    rid = @params.rid
    @body = yield db.rnd.publish rid
