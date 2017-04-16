require! {
  \../../models
  \../validator
}

handler = async (ctx) ->
  {pack} = ctx.params

  pack = await models.Packs.find-by-id pack, 'permit beginTime endTime' .exec!
  await ctx.assert-exist pack, \r, ctx.params.pack, \Pack

  if !pack.permit.check-owner ctx.state.user
    ctx.assert-name \UnfinishedPack, false, _id: pack._id, type: \Pack, user: ctx.state.user._id

  query = models.Submissions.aggregate do
    * $match:
        pack: pack._id
        date:
          $gte: pack.begin-time
          $lte: pack.end-time
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
  path: \/pack/:pack/board
  validate:
    params:
      pack: validator.pack!
  handler: handler
