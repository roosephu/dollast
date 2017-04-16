require! {
  \debug
  \flat
  \koa-joi-router : {Joi}
  \../../models
  \../validator
}

log = debug \dollast:ctrl:pack:save

handler = async (ctx) ->
  # TODO: validation
  pack = ctx.request.body
  log {pack}

  if pack._id == void
    pack._id = await models.Packs.next-count!
    # TODO: can this user add a pack?
  else
    existed = await models.Packs.find-by-id pack._id, \permit .exec!
    await ctx.assert-exist existed, \w, pack._id, \Pack

    delete pack.permit

    # flat it!
    pack |>= flat
    for submission in await models.Submissions.find pack: pack._id .exec!
      submission.hidden = true
      submission.save!

  # always set true, so that the triggers can find it and try to update all solutions
  pack.flag = true

  ctx.body = await models.Packs.update _id: pack._id, pack, upsert: true .exec!

  ctx.body =
    _id: pack._id
    detail: "pack saved"

module.exports =
  method: \POST
  path: \/pack
  validate:
    type: \json
    body:
      _id: validator.pack!.optional!
      title: Joi .string! .min 3 .max 63
      begin-time: Joi .date! .timestamp!
      end-time: Joi .date! .timestamp!
      permit: validator.permit!
  handler: handler
