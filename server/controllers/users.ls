require! {
  \co
  \prelude-ls : {difference, map}
  \debug
  \../models
  \../config
}

log = debug \dollast:ctrl:user

export save = co.wrap (ctx) ->*
  # ctx.acquire-privilege \login
  ctx.check-body '_id' .len config.uid-min-len, config.uid-max-len

  delete ctx.request.body.pswd # should check once here
  return if ctx.errors?.length > 0

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
      groups: []
      permit:
        owner: uid
        group: \admin
        access: \rw-rw----

    user.set-password password
    yield user.save!

    ctx.body =
      type: \register
      payload: "register successful"

export profile = co.wrap (ctx) ->*
  {uid} = ctx.params

  profile = yield models.users.find-by-id uid, \-password .lean! .exec!
  solved-problem-ids = yield models.submissions.get-user-solved-problem-ids uid
  solved-problems = yield models.problems.populate solved-problem-ids, path: '_id', select: '_id outlook.title'
  solved-problems = map (._id), solved-problems 

  owned-problems = yield models.problems.get-user-owned-problems uid
  owned-rounds = yield models.rounds.get-user-owned-rounds uid
  ctx.body = {profile, solved-problems, owned-problems, owned-rounds}
