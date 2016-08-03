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
        tr(v-for="record in board")
          td
            user(:user="record[0]")
          td {{record[1].total}}
          td(v-for="problem in problems")
            a(href="#!/submission/{{record[1][problem._id].solution}}") {{record[1][problem._id].score}}
  
    p Note: only last submission is considered. 
</template>

<script lang="vue-livescript">
require! {
  \debug
  \vue
  \co
  \prelude-ls : {obj-to-pairs, sort, reverse}
  \../view
  \../format
  \../../actions : {raise-error}
}

log = debug \dollast:component:pack:board

generate-board = (submissions) ->
  board = {}
  for submission in submissions
    {user, problem} = submission._id
    board[user] ||= total: 0
    board[user][problem] = submission{score, solution}
    board[user].total += submission.score
  board

module.exports =
  vuex:
    actions:
      {raise-error}

  components:
    {view} <<< format{problem, code-link, user}

  data: ->
    board: []
    problems: []

  route:
    data: co.wrap (to: params: {pack}) ->*
      {data: response} = yield vue.http.get "pack/#{pack}"
      if response.errors
        @raise-error response
        return null
      pack = response.data

      {data: response} = yield vue.http.get "pack/#{pack._id}/board"
      if response.errors
        @raise-error response
        return null
      submissions = response.data

      board = generate-board submissions |> obj-to-pairs |> sort |> reverse
      {board} <<<< pack{problems}

</script>
