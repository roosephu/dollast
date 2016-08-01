require! {
  \prelude-ls : {map}
  \../validator
  \../../models
}

handler = ->*
  {user} = @params

  profile = yield models.Users.find-by-id user, \-password .lean! .exec!
  solved-problem-ids = yield models.Submissions.get-user-solved-problem-ids user
  solved-problems = yield models.Problems.populate solved-problem-ids, path: '_id', select: '_id outlook.title'
  solved-problems = map (._id), solved-problems 

  owned-problems = yield models.Problems.get-problems-by-user user
  owned-packs = yield models.Packs.get-packs-by-user user
  @body = {profile, solved-problems, owned-problems, owned-packs}

module.exports = 
  method: \GET
  path: \/user/:user
  validate:
    params:
      user: validator.user!
  handler: handler