<template lang="jade">
  table.ui.table.segment.large.green.selectable
    thead
      tr
        th user
        th total
        th(v-for="prob in probs")
          problem(:prob="prob")
    tbody
      tr(v-for="[user, score] in board")
        td
          user(:uid="user")
        td {{score.total}}
        td(v-for="prob in probs")
          code-link(:sid="score[pid].sid")
</template>

<script lang="vue-livescript">
require! {
  \debug
  \vue
  \co
  \../format
  \prelude-ls : {obj-to-pairs, sort, reverse}
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

module.exports =
  components:
    format{problem, code-link, user}

  data: ->
    board: []

  route:
    data: co.wrap (to: params: {rid}) ->*
      {data: sols} = yield vue.http.get "/round/#{rid}/board"
      {data: round} = yield vue.http.get "/round/#{rid}"
      board = generate-board sols |> obj-to-pairs |> sort |> reverse
      {board}

</script>
