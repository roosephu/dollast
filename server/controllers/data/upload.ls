require! {
  \../validator
  \../../models
}

handler = ->*
  log \uploading
  {pid} = @params

  problem = yield models.Problems.find-by-id pid, \permit .exec!
  yield @assert-exist problem, \w, pid, \Problem

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