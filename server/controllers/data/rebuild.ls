require! {
  \../../models
}

handler = ->*
  {pid} = @params

  problem = yield models.Problems.find-by-id pid, "config.dataset permit" .exec!
  yield @assert-exist problem, \w, pid, \Problem
  
  new-pairs = yield problem.rebuild!
  @body = new-pairs

module.exports = 
  method: \GET
  path: \/data/:problem/rebuild
  handler: handler