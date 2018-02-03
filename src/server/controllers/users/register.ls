require! {
  \debug
  \koa-joi-router : {Joi}
  \../validator
  \../err : {assert-name: assert}
  \../../models
}

log = debug \dollast:server:users:register

handler = (ctx) ->>
  {user, password} = ctx.request.body
  log ctx.request.body

  existence = await models.Users.find-by-id user .count! .exec!
  assert \ValidationError, existence == 0, [
    message: "duplicate user id"
    path: "user"
  ]

  user = new models.Users do
    _id: user
    groups: []
    permit:
      owner: user
      group: \admin
      access: \rw-rw----

  user.set-password password
  await user.save!

  ctx.body =
    type: \register
    payload: "register successful"

module.exports =
  method: \POST
  path: \/user/register
  validate:
    type: \json
    body:
      user: validator.user!
      password: Joi .string! .required! .min 8 .max 15
      email: validator.email!
  handler: handler
