require! {
  \co
  \../models
  \../core
  \../Exception
  \co-busboy
  \debug
}

log = debug \dollast:ctrl:data

export upload = co.wrap (ctx) ->*
  log \uploading
  {pid} = ctx.params

  problem = yield models.problems.find-by-id pid, \permit .exec!
  if not problem
    throw new Exception "no such problem"
  problem.permit.check-access ctx.state.user, \w

  parts = co-busboy ctx, auto-fields: true
  while part = yield parts
    log {part}
    ctx.body = yield core.upload pid, part # TODO
  pairs = yield problem.repair!

  ctx.body <<< status:
    type: "ok"
    msg: "upload successful"
    data:
      {pairs}

export rebuild = co.wrap (ctx) ->*
  {pid} = ctx.params

  problem = yield models.problems.find-by-id pid, "config.dataset permit" .exec!
  if not problem
    throw new Exception 'xxx'
  problem.permit.check-access ctx.state.user, \w
  
  new-pairs = yield problem.rebuild!
  ctx.body = new-pairs

export remove = co.wrap (ctx) ->* # validate
  {pid, file} = ctx.params

  problem = yield models.problems.find-by-id pid, "config.dataset permit" .exec!
  if not problem
    throw new Exception "xxx"
  problem.permit.check-access ctx.state.user, \w

  yield core.delete-test-data pid, ctx.params
  yield problem.repair!

  ctx.body = status:
    type: "ok"
    msg: "data has been deleted"

# export show = co.wrap (ctx) ->*
#   ctx.ensure-access models.problems.model, pid, \w
#   data = yield models.problems.list-dataset ctx.params.pid
#   ctx.body = data
