require! {
  \../../models
  \../validator
}

handler = async (ctx) ->
  {round} = ctx.params

  round = await models.Rounds.find-by-id round, 'permit beginTime endTime' .exec!
  await ctx.assert-exist round, \r, ctx.params.round, \Round

  if !round.permit.check-owner ctx.state.user
    ctx.assert-name \UnfinishedRound, false, _id: round._id, type: \Round, user: ctx.state.user._id

  query = models.Submissions.aggregate do
    * $match:
        round: round._id
        date:
          $gte: round.begin-time
          $lte: round.end-time
    * $sort: problem: 1, user: 1, date: -1
    * $group:
        _id:
          problem: \$problem
          user: \$user
        score:
          $first: '$summary.score'
        solution:
          $first: \$_id

  ctx.body = await query.exec!

module.exports =
  method: \GET
  path: \/round/:round/board
  validate:
    params:
      round: validator.round!
  handler: handler
