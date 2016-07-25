require! {
  \koa-joi-router : {Joi}
  \prelude-ls : {difference, map}
  \../../config : {uid-min-len, uid-max-len}
  \../../models
}

handler = ->*
  # @acquire-privilege \login

  delete @request.body.pswd # should check once here
  return if @errors?.length > 0

  {_id, groups} = @request.body

  user = yield models.users.find-by-id _id .exec!
  if not user
    @body = status:
      type: \error
      message: "no such user"

  user.permit.check-access @state.user, \w

  priv-diff = difference user.groups, groups
  if priv-diff? and priv-diff.length > 0
    user.permit.check-admin @state.user
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
    body: Joi .object! .options presence: \required .keys do
      _id : Joi .string! .min uid-min-len .max uid-max-len
  handler: handler