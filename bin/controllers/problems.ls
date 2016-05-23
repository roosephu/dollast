require! {
  \../db
  \debug
}

log = debug \dollast:ctrls:prob

export list = ->*
  @body = yield db.problems.list @query
  log "prob-list #{@body}"

export next-count = ->*
  @body =
    type: \success
    payload:
      _id: yield db.problems.next-count!

export show = ->*
  @body = yield db.problems.show @params.pid, mode: "view"

export total = ->*
  @body = yield db.problems.show @params.pid, mode: "total"

export brief = ->*
  @body = yield db.problems.show @params.pid, mode: "brief"

export save = ->*
  req = @request.body
  log {req}
  #@check-body 'method' .in ['modify', 'create'], 'wrong method'
  # log req.outlook.title
  @check-body \/outlook/title, true .get! .len 1, 63
  # @check req.outlook, 'title' .len 1, 63
  #@check req.outlook, 'inFmt' .not-empty!
  #@check req.outlook, 'outFmt' .not-empty!
  #@check req.outlook, 'sampleIn' .not-empty!
  #@check req.outlook, 'sampleOut' .not-empty!
  @check-body \/config/timeLmt, true .get! .is-float! .gt 0
  @check-body \/config/spaceLmt, true .get! .is-float! .gt 0
  @check-body \/config/stkLmt, true .get! .is-float! .gt 0
  @check-body \/config/outLmt, true .get! .is-float! .gt 0
  @check-body \/config/judger, true .get! .in [\string, \strict, \real, \custom]
  @check-body \/permit/owner, true .get!
  return if @errors

  @body = yield db.problems.modify @params.pid, @request.body
  @body <<< status:
    type: "ok"
    msg: "problem has been saved"

export remove = ->*
  ...

export repair = ->*
  new-pairs = yield db.problems.upd-data @params.pid
  @body =
    type: 'server/success'
    payload: new-pairs

export stat = ->*
  @body = yield db.problems.stat @params.pid
