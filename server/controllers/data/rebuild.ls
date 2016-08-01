require! {
  \../../models
}

handler = ->*
  {pid} = @params

  problem = yield models.Problems.find-by-id pid, "config.dataset permit" .exec!
  if not problem
    throw new Exception 'xxx'
  problem.permit.check-access @state.user, \w
  
  new-pairs = yield problem.rebuild!
  @body = new-pairs

module.exports = 
  method: \GET
  path: \/data/:problem/rebuild
  handler: handler