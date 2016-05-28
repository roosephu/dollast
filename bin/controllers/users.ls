require! {
  \../db
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

  user = yield db.users.find-by-id _id .exec!
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
  {uid, pswd} = @request.body

  if yield db.users.find-by-id uid .count! .exec!
    @body =
      type: \register
      error: true
      payload: "duplicate user id"

  else
    user = new db.users do
      _id: uid
      pswd: pswd
      groups: []
      permit:
        owner: uid
        group: \admin
        access: \rw-rw----

    salt = bcrypt.gen-salt-sync bcrypt.bcrypt-cost
    user.pswd = bcrypt.hash-sync user.pswd, salt
    yield user.save!

    @body =
      type: \register
      payload: "register successful"

export profile = ->*
  {uid} = @params

  profile = yield db.users.find-by-id uid, \-pswd .lean! .exec!
  solved-problems = yield db.solutions.get-user-solved-problems uid
  owned-problems = yield db.problems.get-user-owned-problems uid
  owned-rounds = yield db.rounds.get-user-owned-rounds uid
  @body = {profile, solved-problems, owned-problems, owned-rounds}
