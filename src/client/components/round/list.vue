<template lang="jade">
Window
  .menu(slot="config")
    .ui.header filter
    .item.icon#filter
      i.dropdown.icon
      i.icon.filter
      span Filter
      .menu
        .item(v-for="item in options", :data-value="item")
          | {{item}}
    .ui.divider
    .ui.header operations
    RouterLink.item(to="/round/create")
      i.icon.plus
      | Add a Round

  .ui.basic.segment(:class="{loading: isLoading}", slot="main")
    h1.ui.header.dividing Rounds

    .ui.very.relaxed.divided.link.list
      .item(v-for="round in rounds")
        .ui.right.floated
          | start from
          .ui.label {{round.beginTime | time}}
          | duration
          .ui.label {{round | roundDuration}}
          //- | to
          //- .ui.label {{round.endTime | time}}
        .description
          RoundLink(:round="round")
</template>

<script>
import { mapGetters } from 'vuex'
import { debug } from 'debug'
import moment from 'moment'
import Window from '@/components/Window'
import RoundLink from '@/components/format/RoundLink'
import gql from 'graphql-tag'

const log = debug('dollast:component:round:list')

export default {
  components: {
    Window,
    RoundLink
  },

  data () {
    return {
      options: {'All': 'All', 'Past': 'Past', 'Running': 'Running', 'Pending': 'Pending'},
      rounds: []
    }
  },

  computed: {
    ...mapGetters(['isLoading'])
  },

  // methods: {
  //   duration (round) {
  //     log(moment(round.endTime) - moment(round.beginTime))
  //     return round ? moment.duration(moment(round.endTime) - moment(round.beginTime)).humanize() : ''
  //   }
  // },

  apollo: {
    rounds: {
      query: gql`query {
        rounds {
          _id
          index
          title
          beginTime
          endTime
        }
      }`
    }
  },

  mounted () {
    this.$nextTick(() => {
      $('#configuration').dropdown({
        on: 'hover'
      })

      const $filter = $('#filter')
      $filter.dropdown({
        onChange (value, text, $choice) {
          log({value, text, $choice})
        }
      })
      $filter.dropdown('set text', 'all')
    })
  }
}
</script>
