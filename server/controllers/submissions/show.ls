require! {
  \debug
  \../../models
  \../validator
}

log = debug \dollast:ctrl:submissions:show

handler = ->*
  {submission} = @params
  log \preparing, {submission} 

  submission = yield models.submissions.find-by-id submission
    .populate \problem, 'outlook.title'
    .exec!
  @assert submission, id: submission, type: \submission, detail: "doesn't exists"

  submission.check-access @state.user, \r

  @body = submission

module.exports = 
  method: \GET
  path: \/submission/:submission
  validate:
    params:
      submission: validator.submission!
  handler: handler
