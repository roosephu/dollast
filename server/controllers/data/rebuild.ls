require! {
  \../validator
  \../../models
}

handler = ->*
  {problem} = @params

  problem = yield models.Problems.find-by-id problem, "config.dataset permit" .exec!
  yield @assert-exist problem, \w, @params.problem, \Problem
  
  new-pairs = yield problem.rebuild!
  @body = new-pairs

module.exports = 
  method: \GET
  path: \/data/:problem/rebuild
  validate:
    params:
      problem: validator .problem!
  handler: handler