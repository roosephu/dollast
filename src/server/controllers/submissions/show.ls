require! {
  \debug
  \../../models
  \../validator
}

log = debug \dollast:ctrl:submissions:show

handler = (ctx) ->>
  {submission} = ctx.params
  log \preparing, {submission}

  submission = await models.Submissions.find-by-id submission
    .populate \problem, 'outlook.title'
    .exec!
  await ctx.assert-exist submission, \r, ctx.params.submission, \Submission

  ctx.body = submission

module.exports =
  method: \GET
  path: \/submission/:submission
  validate:
    params:
      submission: validator.submission!
  handler: handler
