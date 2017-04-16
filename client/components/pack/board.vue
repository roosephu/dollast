<template lang="jade">
window
  .menu(slot="config")
    .ui.header links
    a.item(:href="'#!/pack/' + pack._id")
      i.icon.left.arrow
      | Go to Pack

  .ui.basic.segment(:class="{loading: isLoading}", slot="main")
    table.ui.table.segment.large.green.selectable
      thead
        tr
          th user
          th total
          th(v-for="problem in pack.problems")
            problem(:prob="problem")
      tbody
        tr(v-for="record in board")
          td
            user(:user="record[0]")
          td {{record[1].total}}
          td(v-for="problem in pack.problems")
            a(:href="'#!/submission/' + record[1][problem._id].solution") {{record[1][problem._id].score}}

    p Note: only last submission is considered.
</template>

<script>
require! {
  \debug
  \vuex : {default: {map-actions, map-getters}}
  \prelude-ls : {obj-to-pairs, sort, reverse}
  \../window
  \../format
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

  components:
    {window} <<< format{problem, code-link, user}

  computed: map-getters [\isLoading]

  data: ->
    board: []
    pack:
      problems: []
      _id: "0"

  methods: (map-actions [\$fetch]) <<<
    fetch: ->>
      @pack = await @$fetch method: \GET, url: "pack/#{@$route.params.pack}"
      submissions = await @$fetch method: \GET, url: "pack/#{@$route.params.pack}/board"
      @board = generate-board submissions |> obj-to-pairs |> sort |> reverse

  watch:
    $route: ->
      @fetch!

  created: ->
    @fetch!

</script>
