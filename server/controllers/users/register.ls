require! {
  \koa-joi-router : {Joi}
  \../../models
}

handler = ->*

  {user, password} = @request.body

  if yield models.users.find-by-id user .count! .exec!
    @body =
      type: \register
      error: true
      payload: "duplicate user id"

  else
    user = new models.users do
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
    body: Joi .object! .options presence: \required .keys do
      user: Joi .string! .min 4 .max 15
      password: Joi .string! .min 8 .max 15
  handler: handler
