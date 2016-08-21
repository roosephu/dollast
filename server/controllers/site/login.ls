require! {
  \koa-joi-router : {Joi}
  \jsonwebtoken : jwt
  \prelude-ls : {lists-to-obj}
  \debug
  \../err : {assert-name: assert}
  \../../models
  \../../config
  \../validator
}

log = debug \dollast:ctrl:site:login

handler = ->*
  # @check-body '_id' .len 6, 15
  # @check-body 'pswd' .non-empty!
  {user, password} = @request.body
  return if @errors?.length > 0

  user = yield models.Users.find-by-id user .exec!
  assert \LoginError, (user and user.check-password password), 
    _id: @request.body.user

  groups = user.groups
  groups.push \login
  @state.user.groups = lists-to-obj groups, [true for i from 1 to groups.length]

  payload =
    _id: user._id
    groups: @state.user.groups
  header = 
    alg: config.jwt.alg
    iss: \dollast
    exp: config.jwt.get-exp!
  log header

  token = jwt.sign payload, config.jwt.key, {header, no-timestamp: true}
  log jwt.decode token
  @body = {token}

module.exports = 
  method: \POST
  path: \/site/login
  validate:
    type: \json
    body:
      user: validator.user!
      password: Joi .string! .min 8 .max 16
  handler: handler