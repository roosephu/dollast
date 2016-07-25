require! {
  \prelude-ls : {map}
  \../../models
}

handler = ->*
  {user} = @params

  profile = yield models.users.find-by-id user, \-password .lean! .exec!
  solved-problem-ids = yield models.submissions.get-user-solved-problem-ids user
  solved-problems = yield models.problems.populate solved-problem-ids, path: '_id', select: '_id outlook.title'
  solved-problems = map (._id), solved-problems 

  owned-problems = yield models.problems.get-problems-by-user user
  owned-packs = yield models.packs.get-packs-by-user user
  @body = {profile, solved-problems, owned-problems, owned-packs}

module.exports = 
  method: \GET
  path: \/user/:user
  handler: handler