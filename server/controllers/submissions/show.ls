require! {
  \debug
  \../../models
  \../validator
}

log = debug \dollast:ctrl:submissions:show

handler = ->*
  {submission} = @params
  log \preparing, {submission} 

  submission = yield models.Submissions.find-by-id submission
    .populate \problem, 'outlook.title'
    .exec!
  yield @assert-exist submission, \r, @params.submission, \Submission 

  @body = submission

module.exports = 
  method: \GET
  path: \/submission/:submission
  validate:
    params:
      submission: validator.submission!
  handler: handler
