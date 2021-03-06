<template lang="jade">
Window(v-if="round")
  .menu(slot="config")
    .ui.header links
    RouterLink.item(:to="{name: 'submissions', query: {round: round._id}}")
      i.icon
      | All Submissions
    .ui.divider
    .ui.header filter
    .item#filter
      i.dropdown.icon
      i.icon.filter
      span Filter
      .menu
        .item(v-for="item in options", :data-value="item")
          | {{item}}
    .ui.divider
    .ui.header operations
    RouterLink.item(to="/problem/create")
      i.icon.plus
      | Add a Problem
    RouterLink.item(:to="'/round/' + roundId + '/board'")
      i.icon.trophy
      | Board
    RouterLink.item(:to="'/round/' + roundId + '/update'")
      i.icon.edit
      | Update

  .ui.basic.segment(:class="{loading: isLoading}", slot="main")
    h1.ui.dividing.header Round {{round | round}}

    //- .ui.olive.labels
    //-   .ui.label {{round.permit.owner}}
    //-     .detail owner
    //-   .ui.label {{round.permit.group}}
    //-     .detail group

    .ui.progress
      .bar
        .progress
      .label
        | start at
        .ui.label {{round.beginTime | time}}
        | duration
        .ui.label {{round | roundDuration}}

    .ui.header

    div(v-if="started")
      h2.ui.dividing.header Problemset
      .ui.very.relaxed.divided.link.list
        .item(v-for="prob in problems")
          .ui.right.floated ??
          .description
            ProblemLink(:prob="prob")
      br

    div(v-else)
      h3.header Sorry, this round has not started.
</template>

<script>
import { mapGetters } from 'vuex'
import { debug } from 'debug'
import moment from 'moment'
import Window from '@/components/Window'
import ProblemLink from '@/components/format/ProblemLink'
import '@/components/format'
import gql from 'graphql-tag'
import * as _ from 'lodash'

const log = debug('dollast:component:round:show')

export default {
  components: {
    ProblemLink,
    Window
  },

  data () {
    return {
      options: ['All', 'Failed', 'Accepted', 'New'],
      round: null
    }
  },

  computed: {
    started () {
      return moment().isAfter(this.round.beginTime)
    },

    roundId () {
      return this.$route.params.roundId
    },

    ...mapGetters(['isLoading'])
  },

  apollo: {
    problems: {
      query: gql`query ($roundId: ID) {
        problems(round: $roundId) {
          _id
          index
          title
        }
      }`,
      variables () {
        return { roundId: this.roundId }
      }
    },

    round: {
      query: gql`query ($roundId: ID!) {
        round(_id: $roundId) {
          _id
          index
          title
          beginTime
          endTime
        }
      }`,
      variables () {
        return { roundId: this.roundId }
      }
    }
  },

  watch: {
    round () {
      const beginTime = moment(this.round.beginTime)
      const endTime = moment(this.round.endTime)
      const current = moment()
      this.$nextTick(() => {
        $('.ui.progress').progress({
          total: endTime - beginTime,
          value: _.max([current - beginTime, 0])
        })
      })

      $('#configuration').dropdown({ on: 'hover' })

      const $filter = $('#filter')
      $filter.dropdown({
        onChange (value, text, $choice) {
          log({value, text, $choice})
        }
      })
      $filter.dropdown('set text', 'All')
    }
  }
}
</script>
