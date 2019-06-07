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
        tr(v-for="record in round.board")
          td
            UserLink(:user="record[0]")
          td {{record[1].total}}
          td(v-for="problem in round.problems")
            RouterLink(:to="'/submission/' + record[1][problem._id]._id") {{record[1][problem._id].score}}

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
    const { user, problem, _id, score } = submission
    const { _id: userId } = user
    const { _id: problemId } = problem
    board[userId] = board[userId] || { total: 0 }
    board[userId][problemId] = { score, _id }
    board[userId].total += submission.score
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
    board () {
      return generateBoard(this.round.board)
    },

    ...mapGetters(['isLoading'])
  },

  apollo: {
    round: {
      query: gql`query ($_id: ID!) {
        round(_id: $_id) {
          _id
          index
          title
          board {
            _id
            user {
              _id
            }
            problem {
              _id
            }
            index
            summary {
              score
            }
          }
        }
      }`,
      variables () {
        return { _id: this.$route.params.roundId }
      }
    }
  },

  data () {
    return {
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
