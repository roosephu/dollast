require! {
  "../db"
  \debug
}

log = debug \dollast:ctrl:round

export
  list: ->*
    @body = yield db.rounds.list!

  next-count: ->*
    @acquire-privilege \login
    @body = _id: yield db.rounds.next-count!

  show: ->*
    @body = yield db.rounds.show @params.rid, mode: "view"

  save: ->*
    @acquire-privilege \login
    # log {body: @request.body}
    yield db.rounds.modify @params.rid, @request.body
    @body = status:
      type: "ok"
      msg: "round saved"

  total: ->*
    @acquire-privilege \login
    @body = yield db.rounds.show @params.rid, mode: "total"

  remove: ->*
    @acquire-privilege \login
    yield db.rounds.delete @params.rid
    @body = status:
      type: "ok"
      msg: "round has been deleted"

  board: ->*
    rid = @params.rid
    @body = yield db.rounds.board rid

  publish: ->*
    @acquire-privilege \login
    rid = @params.rid
    @body = yield db.rounds.publish rid
