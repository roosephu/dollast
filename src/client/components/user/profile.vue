<template lang="jade">
Window
  .menu(slot="config")
    .ui.header links
    RouterLink.item(:to="{name: 'submissions', query: {user: user._id}}")
      i.icon
      | All submissions
    .ui.divider
    .ui.header operations
    RouterLink.item(:to="'/user/' + user._id + '/update'")
      i.icon.edit
      | Update

  .ui.basic.segment(:class="{loading: isLoading}", slot="main")
    h1.ui.dividing.header Details of {{user | user}}
    .ui.segment
      .ui.top.attached.label.large registered since
      p {{registerDate}}

    .ui.segment
      .ui.large.top.attached.label description
      p {{user.description}}

    // .ui.segment
    //   .ui.top.attached.label.large Groups
    //   .ui.olive.label(v-for="group in user.groups") {{group}}

    .ui.segment
      .ui.top.attached.label.large Problems solved
      .ui.relaxed.divided.link.list
        .item(v-for="prob in sortByIndex(user.solvedProblems)")
          .description
            ProblemLink(:prob="prob")

    .ui.segment
      .ui.top.attached.label.large Problems owned
      .ui.relaxed.divided.link.list
        .item(v-for="prob in sortByIndex(ownedProblems)")
          .description
            ProblemLink(:prob="prob")

    .ui.segment
      .ui.top.attached.label.large Rounds owned
      .ui.relaxed.divided.link.list
        .item(v-for="round in sortByIndex(ownedRounds)")
          .ui.right.floated
            .ui.label {{round.beginTime | time}}
            | to
            .ui.label {{round.endTime | time}}
          .description
            RoundLink(:round="round")
</template>

<script>
import { mapGetters } from 'vuex'
import moment from 'moment'
import { debug } from 'debug'
// import naturalSort from 'javascript-natural-sort'
import Window from '@/components/Window'
import ProblemLink from '@/components/format/ProblemLink'
import RoundLink from '@/components/format/RoundLink'
import gql from 'graphql-tag'

const log = debug('dollast:components:user:profile')

export default {
  data () {
    return {
      user: { _id: null },
      ownedProblems: [],
      ownedRounds: []
    }
  },

  computed: {
    registerDate () {
      return this.user.date && moment(this.user.date).format('MMMM Do YYYY')
    },

    ...mapGetters(['isLoading'])
  },

  methods: {
    sortByIndex (x) {
      return x && [...x].sort((a, b) => a.index < b.index)
    }
  },

  apollo: {
    user: {
      query: gql`query ($_id: ID!) {
        user(_id: $_id) {
          _id
          email
          description
          date
          solvedProblems {
            _id
            index
            title
          }
        }
      }`,
      variables () {
        return { _id: this.$route.params.userId }
      }
    }
  },

  components: {
    Window,
    ProblemLink,
    RoundLink
  }
}
</script>
