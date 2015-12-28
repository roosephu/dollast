require! {
  \react : {create-class}
  \react-redux : {connect}
  \../../actions : {on-get-round-board, on-get-round}
  \../elements : {prob-link, user-link, code-link}
  \immutable : I
  \prelude-ls : {sort, obj-to-pairs, reverse}
}

log = debug \dollast:component:round:board

generate-board = (sols) ->
  board = {}
  for sol in sols
    {user, prob} = sol._id
    board[user] ||= total: 0
    board[user][prob] = sol{score, sid}
    board[user].total += sol.score
  board

selector = (state, props) ->
  rid = props.params.rid
  sols: state.get-in [\db, \round, rid, \board, \get], I.from-JS []
  probs: state.get-in [\db, \round, rid, \get], I.from-JS []

module.exports = (connect selector) create-class do
  display-name: \rnd-board

  component-did-mount: ->
    @props.dispatch on-get-round-board @props.params.rid
    @props.dispatch on-get-round @props.params.rid, \show

  render: ->
    sols = @props.sols.to-JS!
    probs = @props.probs.to-JS!

    board = generate-board sols |> obj-to-pairs |> sort |> reverse
    # log {board, probs}

    _ \div, null,
      _ \table, class-name: "ui table segment large green selectable",
        _ \thead, null,
          _ \tr, null,
            _ \th, null, \user
            _ \th, null, \total
            for prob in probs
              _ \th, null,
                _ prob-link, {prob}
        _ \tbody, null,
          for [user, score] in board
            _ \tr, null,
              _ \td, null,
                _ user-link, user: user
              _ \td, null,
                score.total
              for prob in probs
                pid = prob._id
                if score[pid]
                  _ \td, null,
                    _ code-link, sid: score[pid].sid, text: score[pid].score
                else
                  _ \td, null
