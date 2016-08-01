require! {
  \koa-joi-router : {Joi}
  \../validator
  \../../models
}

handler = ->*
  {user, password} = @request.body

  if yield models.Users.find-by-id user .count! .exec!
    @body =
      type: \register
      error: true
      payload: "duplicate user id"

  else
    user = new models.Users do
      _id: user
      groups: []
      permit:
        owner: user
        group: \admin
        access: \rw-rw----

    user.set-password password
    yield user.save!

    @body =
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
  handler: handler
