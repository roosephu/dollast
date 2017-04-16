require! {
  \debug
  \../validator
  \../../models
  \../../core
}

log = debug \dollast:ctrl:data:upload

handler = async (ctx) ->
  log \uploading
  {problem} = ctx.params

  problem = await models.Problems.find-by-id problem, \permit .exec!
  await ctx.assert-exist problem, \w, ctx.params.problem, \Problem

  parts = ctx.request.parts
  # while (part = (await parts))
  #   ctx.body = await core.upload.call ctx., problem._id, part
  pairs = await problem.rebuild!

  ctx.body =
    dataset:
      pairs

module.exports =
  method: \POST
  path: \/data/:problem/upload
  validate:
    type: \multipart
    max-body: '16MB'
    params:
      problem: validator.problem!
  handler: handler
