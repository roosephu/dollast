require! {
  \co
  \../models
  \../config
  \prelude-ls : {difference}
  \debug
  \bcrypt
}

log = debug \dollast:ctrl:user

export save = co.wrap (ctx) ->*
  # ctx.acquire-privilege \login
  ctx.check-body '_id' .len config.uid-min-len, config.uid-max-len

  delete ctx.request.body.pswd # should check once here
  return if ctx.errors

  {_id, groups} = ctx.request.body

  user = yield models.users.find-by-id _id .exec!
  if not user
    ctx.body = status:
      type: \error
      message: "no such user"

  user.permit.check-access ctx.state.user, \w

  priv-diff = difference user.groups, groups
  if priv-diff? and priv-diff.length > 0
    user.permit.check-admin ctx.state.user
  delete ctx.request.body.permit

  user <<< ctx.request.body
  yield user.save!

  ctx.body = status:
    type: "ok"
    msg: "user profile saved"

export register = co.wrap (ctx) ->*
  # ctx.check-body '_id' .len 6, 15
  # ctx.check-body 'pswd' .len 8, 15
  {uid, password} = ctx.request.body

  if yield models.users.find-by-id uid .count! .exec!
    ctx.body =
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

    ctx.body =
      type: \register
      payload: "register successful"

export profile = co.wrap (ctx) ->*
  {uid} = ctx.params

  profile = yield models.users.find-by-id uid, \-password .lean! .exec!
  solved-problems = yield models.solutions.get-user-solved-problems uid
  owned-problems = yield models.problems.get-user-owned-problems uid
  owned-rounds = yield models.rounds.get-user-owned-rounds uid
  ctx.body = {profile, solved-problems, owned-problems, owned-rounds}
