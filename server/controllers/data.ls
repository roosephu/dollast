require! {
  \co
  \../models
  \../core
  \../Exception
  \co-busboy
  \debug
}

log = debug \dollast:ctrl:data

export upload = ->*
  log \uploading
  {pid} = @params

  problem = yield models.problems.find-by-id pid, \permit .exec!
  if not problem
    throw new Exception "no such problem"
  problem.permit.check-access @state.user, \w

  parts = co-busboy ctx, auto-fields: true
  while part = yield parts
    log {part}
    @body = yield core.upload pid, part # TODO
  pairs = yield problem.rebuild!

  @body = 
    dataset: 
      pairs

export rebuild = ->*
  {pid} = @params

  problem = yield models.problems.find-by-id pid, "config.dataset permit" .exec!
  if not problem
    throw new Exception 'xxx'
  problem.permit.check-access @state.user, \w
  
  new-pairs = yield problem.rebuild!
  @body = new-pairs

export remove = ->* # validate
  {pid, file} = @params

  problem = yield models.problems.find-by-id pid, "config.dataset permit" .exec!
  if not problem
    throw new Exception "xxx"
  problem.permit.check-access @state.user, \w

  yield core.delete-test-data pid, @params
  yield problem.rebuild!

  @body = status:
    type: "ok"
    msg: "data has been deleted"

# export show = ->*
#   @ensure-access models.problems.model, pid, \w
#   data = yield models.problems.list-dataset @params.pid
#   @body = data
