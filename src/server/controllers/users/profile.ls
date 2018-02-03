require! {
  \prelude-ls : {map}
  \debug
  \../validator
  \../../models
}

log = debug \dollast:ctrl:user:profile

handler = (ctx) ->>
  {user} = ctx.params

  profile = await models.Users.find-by-id user, \-password .lean! .exec!
  solved-problem-ids = await models.Submissions.get-user-solved-problem-ids user
  log solved-problem-ids
  solved-problems = await models.Problems.populate solved-problem-ids, path: '_id', select: '_id outlook.title'
  solved-problems = map (._id), solved-problems

  owned-problems = await models.Problems.get-problems-by-user user
  owned-rounds = await models.Rounds.get-rounds-by-user user
  ctx.body = {profile, solved-problems, owned-problems, owned-rounds}

module.exports =
  method: \GET
  path: \/user/:user
  validate:
    params:
      user: validator.user!
  handler: handler
