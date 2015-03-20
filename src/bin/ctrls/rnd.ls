require! {
  "../db"
}

export
  list: ->*
    @body = yield db.rnd.list!
  next-count: ->*
    @body = _id: yield db.rnd.next-count!
  show: ->*
    @body = yield db.rnd.show @params.rid, mode: "view"
  save: ->*
    yield db.rnd.modify @params.rid, @request.body
    @body = status:
      type: "ok"
      msg: "round saved"
  total: ->*
    @body = yield db.rnd.show @params.rid, mode: "total"
  delete: ->*
    yield db.rnd.delete @params.rid
    @body = status:
      type: "ok"
      msg: "round has been deleted"
  board: ->*
    rid = @params.rid
    @body = yield db.rnd.board rid
  publish: ->*
    rid = @params.rid
    @body = yield db.rnd.publish rid
