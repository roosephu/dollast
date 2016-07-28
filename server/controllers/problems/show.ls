require! {
  \debug
  \../../models
  \../validator
}

log = debug \dollast:ctrl:problems:show

handler = ->*
  log "finding problem"
  {problem} = @params

  problem = yield models.problems.find-by-id problem
    .populate 'config.pack', \title
    .exec!
  @assert problem, @params._id, \Problem, "doesn't exist"
  problem.permit.check-access @state.user, \r

  # TODO check whether the corresponding pack has started
  problem .= to-object!
  @body = problem

module.exports = 
  method: \GET
  path: \/problem/:problem
  validate:
    params:
      problem: validator.problem!
  handler: handler
