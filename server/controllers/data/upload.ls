require! {
  \../validator
  \../../models
}

handler = ->*
  log \uploading
  {pid} = @params

  problem = yield models.Problems.find-by-id pid, \permit .exec!
  @assert problem, pid, \Problem, "no such problem"
  yield problem.permit.check-access @state.user, \w

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
    max-body: '16MB'
    params:
      problem: validator.problem!
  handler: handler