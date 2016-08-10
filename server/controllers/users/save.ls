require! {
  \koa-joi-router : {Joi}
  \prelude-ls : {difference, map}
  \debug
  \../../models
  \../validator
}

log = debug \dollast:ctrl:user:save

handler = ->*
  # @acquire-privilege \login

  delete @request.body.pswd # should check once here
  return if @errors?.length > 0

  {_id, groups} = @request.body

  user = yield models.Users.find-by-id _id .exec!
  log user
  yield @assert-exist user, \w, _id, \User

  priv-diff = difference user.groups, groups
  if priv-diff? and priv-diff.length > 0
    user.permit.check-admin @state.user
  delete @request.body.permit

  user <<<< @request.body
  yield user.save!

  @body = status:
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