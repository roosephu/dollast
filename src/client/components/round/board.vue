<template lang="jade">
Window
  .menu(slot="config")
    .ui.header links
    RouterLink.item(:to="'/round/' + round._id")
      i.icon.left.arrow
      | Go to Round

  .ui.basic.segment(:class="{loading: isLoading}", slot="main")
    table.ui.table.segment.large.green.selectable
      thead
        tr
          th user
          th total
          th(v-for="problem in round.problems")
            ProblemLink(:prob="problem")
      tbody
        tr(v-for="record in board")
          td
            UserLink(:user="record[0]")
          td {{record[1].total}}
          td(v-for="problem in round.problems")
            a(:href="'/submission/' + record[1][problem._id].solution") {{record[1][problem._id].score}}

    p Note: only last submission is considered.
</template>

<script>
import { mapGetters } from 'vuex'
import { debug } from 'debug'
import Window from '@/components/Window'
import ProblemLink from '@/components/format/ProblemLink'
import SubmissionLink from '@/components/format/SubmissionLink'
import UserLink from '@/components/format/UserLink'
import gql from 'graphql-tag'

const log = debug('dollast:component:round:board')

function generateBoard (submissions) {
  let board = {}
  for (const submission in submissions) {
    const {user, problem} = submission._id
    board[user] = board[user] || { total: 0 }
    board[user][problem] = { score: submission.score, solution: submission.solution }
    board[user].total += submission.score
  }
  return board
}

export default {
  components: {
    Window,
    ProblemLink,
    SubmissionLink,
    UserLink
  },

  computed: {
    ...mapGetters(['isLoading'])
  },

  // apollo: {
  //   round: {
  //     query: gql`query`
  //   }
  // },

  data () {
    return {
      board: [],
      round: {
        problems: [],
        _id: '0'
      }
    }
  }

  // methods: (map-actions [\$fetch]) <<<
  //   fetch: ->>
  //     @round = await @$fetch method: \GET, url: "round/#{@$route.params.round}"
  //     submissions = await @$fetch method: \GET, url: "round/#{@$route.params.round}/board"
  //     @board = generate-board submissions |> obj-to-pairs |> sort |> reverse

  // watch:
  //   $route: ->
  //     @fetch!

  // created: ->
  //   @fetch!

}
</script>
