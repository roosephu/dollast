require! {
  \koa-joi-router : {Joi}
  \prelude-ls : {difference, map}
  \../../models
  \../validator
}

handler = ->*
  # @acquire-privilege \login

  delete @request.body.pswd # should check once here
  return if @errors?.length > 0

  {_id, groups} = @request.body

  user = yield models.users.find-by-id _id .exec!
  @assert user, _id, \User, "doesn't exist"
  user.permit.check-access @state.user, \w

  priv-diff = difference user.groups, groups
  if priv-diff? and priv-diff.length > 0
    user.check-admin @state.user
  delete @request.body.permit

  user <<< @request.body
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
  handler: handler