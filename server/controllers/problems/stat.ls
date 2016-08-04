require! {
  \../../models
  \../validator
}

handler = ->*
  {problem} = @params

  problem = yield models.Problems.find-by-id problem, 'config.pack outlook.title permit'
    .exec!
  yield @assert-exist problem, \r, @params.problem, \Problem

  query = models.Submissions.aggregate do
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
  validate:
    params:
      problem: validator.problem!
  handler: handler