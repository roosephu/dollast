require! {
  \koa-joi-router : {Joi}
  \prelude-ls : {difference, map}
  \debug
  \../../models
  \../validator
}

log = debug \dollast:ctrl:user:save

handler = (ctx) ->>
  # ctx.acquire-privilege \login

  delete ctx.request.body.pswd # should check once here
  return if ctx.errors?.length > 0

  {_id, groups} = ctx.request.body

  user = await models.Users.find-by-id _id .exec!
  log user
  await ctx.assert-exist user, \w, _id, \User

  priv-diff = difference user.groups, groups
  if priv-diff? and priv-diff.length > 0
    user.permit.check-admin ctx.state.user
  delete ctx.request.body.permit

  user <<<< ctx.request.body
  await user.save!

  ctx.body = status:
    type: "ok"
    msg: "user profile saved"

module.exports =
  method: \POST
  path: \/user/:user
  validate:
    type: \json
    body:
      _id : validator.user!
      description: Joi .string!
      groups: Joi .array! .items do
        Joi .string!
  handler: handler
