require! {
  \../models
  \../config
  \prelude-ls : {difference}
  \debug
  \bcrypt
}

log = debug \dollast:ctrl:user

export save = ->*
  # @acquire-privilege \login
  @check-body '_id' .len config.uid-min-len, config.uid-max-len

  delete @request.body.pswd # should check once here
  return if @errors

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

export register = ->*
  # @check-body '_id' .len 6, 15
  # @check-body 'pswd' .len 8, 15
  {uid, password} = @request.body

  if yield models.users.find-by-id uid .count! .exec!
    @body =
      type: \register
      error: true
      payload: "duplicate user id"

  else
    user = new models.users do
      _id: uid
      password: password
      groups: []
      permit:
        owner: uid
        group: \admin
        access: \rw-rw----

    salt = bcrypt.gen-salt-sync bcrypt.bcrypt-cost
    user.password = bcrypt.hash-sync password, salt
    yield user.save!

    @body =
      type: \register
      payload: "register successful"

export profile = ->*
  {uid} = @params

  profile = yield models.users.find-by-id uid, \-password .lean! .exec!
  solved-problems = yield models.solutions.get-user-solved-problems uid
  owned-problems = yield models.problems.get-user-owned-problems uid
  owned-rounds = yield models.rounds.get-user-owned-rounds uid
  @body = {profile, solved-problems, owned-problems, owned-rounds}
