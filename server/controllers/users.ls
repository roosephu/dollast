require! {
  \co
  \prelude-ls : {difference, map}
  \debug
  \../models
  \../config
}

log = debug \dollast:ctrl:user

export save = ->*
  # @acquire-privilege \login
  @check-body '_id' .len config.uid-min-len, config.uid-max-len

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

export register = ->*
  @check-body 'user' .len 4, 15
  @check-body 'password' .len 8, 15

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

export profile = ->*
  {user} = @params

  profile = yield models.users.find-by-id user, \-password .lean! .exec!
  solved-problem-ids = yield models.submissions.get-user-solved-problem-ids user
  solved-problems = yield models.problems.populate solved-problem-ids, path: '_id', select: '_id outlook.title'
  solved-problems = map (._id), solved-problems 

  owned-problems = yield models.problems.get-problems-by-user user
  owned-packs = yield models.packs.get-packs-by-user user
  @body = {profile, solved-problems, owned-problems, owned-packs}
