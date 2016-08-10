require! {
  \debug
  \../../models
  \../validator
}

log = debug \dollast:ctrl:problem:remove

handler = ->*
  {problem} = @params

  problem = yield models.Problems.find-by-id problem, \permit .exec!
  yield @assert-exist problem, \w, @params.problem, \Problem

  yield models.Problems.find-by-id-and-remove problem._id .exec!

  @body = 
    data:
      message: "deleting done"

module.exports = 
  method: \DELETE
  path: \/problem/:problem
  validate:
    params:
      problem: validator.problem!
  handler: handler