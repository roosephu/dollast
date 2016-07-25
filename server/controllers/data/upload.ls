require! {
  \../../models
}

handler = ->*
  log \uploading
  {pid} = @params

  problem = yield models.problems.find-by-id pid, \permit .exec!
  if not problem
    throw new Exception "no such problem"
  problem.permit.check-access @state.user, \w

  parts = yield @request.parts
  while part = yield parts
    log {part}
    @body = yield core.upload pid, part
  pairs = yield problem.rebuild!

  @body = 
    dataset: 
      pairs

module.exports = 
  method: \POST
  path: \/data/:problem/upload
  validate:
    type: \multipart
  handler: handler