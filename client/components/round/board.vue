<template lang="jade">
  table.ui.table.segment.large.green.selectable
    thead
      tr
        th user
        th total
        th(v-for="problem in problems")
          problem(:prob="problem")
    tbody
      tr(v-for="[user, score] in board")
        td
          user(:uid="user")
        td {{score.total}}
        td(v-for="problem in problems")
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

generate-board = (solutions) ->
  board = {}
  for sol in solutions
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
      {data: response} = yield vue.http.get "/round/#{rid}"
      if reseponse.errors
        @raise-error reseponse
        return null
      round = reseponse.data

      {data: response} = yield vue.http.get "/round/#{rid}/board"
      if response.errors
        @raise-error response
        return null
      solutions = response.data

      board = generate-board solutions |> obj-to-pairs |> sort |> reverse
      {board}

</script>
