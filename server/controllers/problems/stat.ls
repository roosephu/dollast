require! {
  \../../models
  \../validator
}

handler = async (ctx) ->
  {problem} = ctx.params

  problem = await models.Problems.find-by-id problem, 'config.round outlook.title permit'
    .exec!
  await ctx.assert-exist problem, \r, ctx.params.problem, \Problem

  query = models.Submissions.aggregate do
    * $match: problem: problem._id
    * $sort: user: 1, "final.score": -1
    * $project:
        language: true
        summary: true
        round: true
        user: true
    * $group:
        _id:
          user: "$user"
        doc:
          $first: "$$CURRENT"
        submits:
          $sum: 1

  submissions = await query.exec!
  delete problem.config
  delete problem.permit

  ctx.body = {submissions, problem}

module.exports =
  method: \GET
  path: \/problem/:problem/stat
  validate:
    params:
      problem: validator.problem!
  handler: handler
