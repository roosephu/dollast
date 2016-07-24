<template lang="jade">
view
  .ui.basic.segment(:class="{loading: $loadingRouteData}", slot="main")
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
            user(:user="user")
          td {{score.total}}
          td(v-for="problem in problems")
            code-link(:sid="score[problem].sid")
</template>

<script lang="vue-livescript">
require! {
  \debug
  \vue
  \co
  \prelude-ls : {obj-to-pairs, sort, reverse}
  \../view
  \../format
}

log = debug \dollast:component:pack:board

generate-board = (submissions) ->
  board = {}
  for sol in submissions
    {user, prob} = sol._id
    board[user] ||= total: 0
    board[user][prob] = sol{score, sid}
    board[user].total += sol.score
  board

module.exports =
  components:
    {view} <<< format{problem, code-link, user}

  data: ->
    board: []

  route:
    data: co.wrap (to: params: {pack}) ->*
      {data: response} = yield vue.http.get "pack/#{pack}"
      if response.errors
        @raise-error response
        return null
      pack = response.data

      {data: response} = yield vue.http.get "pack/#{pack}/board"
      if response.errors
        @raise-error response
        return null
      submissions = response.data

      board = generate-board submissions |> obj-to-pairs |> sort |> reverse
      {board}

</script>
