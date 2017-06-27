require! {
  \debug
  \flat
  \koa-joi-router : {Joi}
  \../../models
  \../validator
}

log = debug \dollast:ctrl:round:save

handler = async (ctx) ->
  # TODO: validation
  round = ctx.request.body
  log {round}

  if not round._id?
    round._id = await models.Rounds.next-count!
    # TODO: can this user add a round?
  else
    existed = await models.Rounds.find-by-id round._id, \permit .exec!
    await ctx.assert-exist existed, \w, round._id, \Round

    delete round.permit

    # flat it!
    round |>= flat
    for submission in await models.Submissions.find round: round._id .exec!
      submission.hidden = true
      submission.save!

  # always set true, so that the triggers can find it and try to update all solutions
  round.flag = true

  ctx.body = await models.Rounds.update _id: round._id, round, upsert: true .exec!

  ctx.body =
    _id: round._id
    detail: "round saved"

module.exports =
  method: \POST
  path: \/round
  validate:
    type: \json
    body:
      _id: validator.round!.optional!
      title: Joi .string! .min 3 .max 63
      begin-time: Joi .date! .timestamp!
      end-time: Joi .date! .timestamp!
      permit: validator.permit!
  handler: handler
