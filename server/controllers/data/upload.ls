require! {
  \debug
  \../validator
  \../../models
  \../../core
}

log = debug \dollast:ctrl:data:upload

handler = ->*
  log \uploading
  {problem} = @params

  problem = yield models.Problems.find-by-id problem, \permit .exec!
  yield @assert-exist problem, \w, @params.problem, \Problem

  parts = @request.parts
  while part = yield parts
    @body = yield core.upload.call @, problem._id, part
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