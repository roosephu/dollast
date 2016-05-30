require! {
  \../models
  \../core
  \co-busboy
  \debug
}

log = debug \dollast:ctrl:data

export upload = ->*
  log \uploading
  {pid} = @params

  problem = yield models.problems.find-by-id pid, \permit .exec!
  if not problem
    throw new Error "no such problem"
  problem.permit.check-access @state.user, \w

  parts = co-busboy @, auto-fields: true
  while part = yield parts
    log {part}
    @body = yield core.upload pid, part
  pairs = yield problem.repair!

  @body <<< status:
    type: "ok"
    msg: "upload successful"
    data:
      {pairs}

export repair = ->*
  {pid} = @params

  problem = yield models.problems.find-by-id pid, "config.dataset permit" .exec!
  if not problem
    throw new Error 'xxx'
  problem.check-access @state.user, \w
  yield problem.repair!

  new-pairs = pairs
  @body =
    type: 'ok'
    payload: new-pairs

export remove = ->* # validate
  {pid, file} = @params

  problem = yield models.problems.find-by-id pid, "config.dataset permit" .exec!
  if not problem
    throw new Error "xxx"
  problem.permit.check-access @state.user, \w

  yield core.delete-test-data pid, @params
  yield problem.repair!

  @body = status:
    type: "ok"
    msg: "data has been deleted"

# export show = ->*
#   @ensure-access models.problems.model, pid, \w
#   data = yield models.problems.list-dataset @params.pid
#   @body = data
