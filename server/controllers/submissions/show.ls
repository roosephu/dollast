require! {
  \../../models
}

handler = ->*
  {submission} = @params

  submission = yield models.submissions.find-by-id submission
    .populate \problem, 'outlook.title'
    .exec!
  @assert submission, id: submission, type: \submission, detail: 'no submission found. '

  submission.permit.check-access @state.user, \r

  @body = submission

module.exports = 
  method: \GET
  path: \/submission/:submission
  handler: handler
