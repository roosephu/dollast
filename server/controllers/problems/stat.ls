require! {
  \../../models
}

handler = ->*
  {problem} = @params

  problem = yield models.problems.find-by-id problem, 'config.pack outlook.title permit'
    .exec!
  if not problem
    throw new Error "no such problem"
  problem.permit.check-access @state.user, \r

  query = models.submissions.aggregate do
    * $match: problem: problem._id
    * $sort: user: 1, "final.score": -1
    * $project:
        language: true
        summary: true
        pack: true
        user: true
    * $group:
        _id:
          user: "$user"
        doc:
          $first: "$$CURRENT"
        submits:
          $sum: 1

  submissions = yield query.exec!
  delete problem.config
  delete problem.permit

  @body = {submissions, problem}

module.exports = 
  method: \GET
  path: \/problem/:problem/stat
  handler: handler