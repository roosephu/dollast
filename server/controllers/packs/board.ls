require! {
  \../../models
  \../validator
}

handler = ->*
  {pack} = @params

  pack = yield models.Packs.find-by-id pack, 'permit beginTime endTime' .exec!
  @assert pack, @params.pack, \Pack, "no such packs"
  yield pack.permit.check-access @state.user, \r

  query = models.Submissions.aggregate do
    * $match: 
        pack: pack._id
        date:
          $gte: pack.begin-time
          $lte: pack.end-time
    * $sort: problem: 1, user: 1, _id: -1
    * $group:
        _id:
          problem: \$problem
          user: \$user
        score:
          $first: '$summary.score'
        solution:
          $first: \$_id

  @body = yield query.exec!

module.exports = 
  method: \GET
  path: \/pack/:pack/board
  validate:
    params:
      pack: validator.pack!
  handler: handler