require! {
  \co
  \../models
  \../core
  \co-busboy
  \debug
}

log = debug \dollast:ctrl:data

export upload = co.wrap (ctx) ->*
  log \uploading
  {pid} = ctx.params

  problem = yield models.problems.find-by-id pid, \permit .exec!
  if not problem
    throw new Error "no such problem"
  problem.permit.check-access ctx.state.user, \w

  parts = co-busboy ctx, auto-fields: true
  while part = yield parts
    log {part}
    ctx.body = yield core.upload pid, part
  pairs = yield problem.repair!

  ctx.body <<< status:
    type: "ok"
    msg: "upload successful"
    data:
      {pairs}

export repair = co.wrap (ctx) ->*
  {pid} = ctx.params

  problem = yield models.problems.find-by-id pid, "config.dataset permit" .exec!
  if not problem
    throw new Error 'xxx'
  problem.check-access ctx.state.user, \w
  yield problem.repair!

  new-pairs = pairs
  ctx.body =
    type: 'ok'
    payload: new-pairs

export remove = co.wrap (ctx) ->* # validate
  {pid, file} = ctx.params

  problem = yield models.problems.find-by-id pid, "config.dataset permit" .exec!
  if not problem
    throw new Error "xxx"
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
