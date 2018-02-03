<template lang="jade">
window
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
    a.item(href="#/round/create")
      i.icon.plus
      | Add a Round

  .ui.basic.segment(:class="{loading: isLoading}", slot="main")
    h1.ui.header.dividing Rounds

    .ui.very.relaxed.divided.link.list
      .item(v-for="round in rounds")
        .ui.right.floated
          .ui.label {{round.beginTime | time}}
          | to
          .ui.label {{round.endTime | time}}
        .description
          round(:round="round")
</template>

<script>
import { mapGetters } from 'vuex'
import { debug } from 'debug'
import window from '@/components/window'
import round from '@/components/format/round'
import gql from 'graphql-tag'

const log = debug('dollast:component:round:list')

export default {
  components: {
    window,
    round
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

  apollo: {
    rounds: {
      query: gql`query {
        rounds {
          _id
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
