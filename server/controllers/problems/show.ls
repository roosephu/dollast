require! {
  \debug
  \../../models
}

log = debug \dollast:ctrl:problems:show

handler = ->*
  log "finding problem"
  {problem} = @params

  problem = yield models.problems.find-by-id problem
    .populate 'config.pack', \title
    .exec!
  if not problem
    @throw do
      _id: problem._id
      type: \problem
      detail: "non-existing problem"
  problem.permit.check-access @state.user, \r

  # TODO check whether the corresponding pack has started
  problem .= to-object!
  @body = problem

module.exports = 
  method: \GET
  path: \/problem/:problem
  handler: handler
