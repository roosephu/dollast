<template lang="jade">
Window
  .ui.basic.segment(:class="{loading: isLoading}", slot="main")
    h1.ui.dividing.header Problem List
    .ui.dropdown.floated.pointing.button.labeled.icon
      input(type="hidden", name="filter")
      .default.text please select filter
      i.dropdown.icon
      .menu
        .item(v-for="item in options", :data-value="item") {{item}}
    a.ui.icon.labeled.button.right.floated.primary(href="#/problem/create")
      i.icon.plus
      | create
    .ui.very.relaxed.divided.link.list#problems
      .item(v-for="problem in problems")
        .ui.right.floated ??
        .ui.description
          ProblemLink(:prob="problem")
</template>

<script>
import { mapGetters } from 'vuex'
import { debug } from 'debug'
import Window from '@/components/Window'
import ProblemLink from '@/components/format/Problem'

const log = debug('dollast:component:problem:list')

export default {
  data () {
    return {
      filter: 'all',
      options: ['all', 'solved', 'unsolved'],
      problems: []
    }
  },

  components: {
    Window,
    ProblemLink
  },

  computed: {
    ...mapGetters(['isLoading'])
  },

  // created: ->
  //   @fetch!

  // watch:
  //   $route: ->
  //     @fetch!

  // methods: (map-actions [\$fetch]) <<<
    // fetch: ->>
    //   @problem = await @$fetch method: \GET, url: \problem

  mounted () {
    const $filter = $('.dropdown')
    $filter.dropdown({
      on: 'hover',
      onChange: (value) => {
        this.filter = value
      }
    })
    $filter.dropdown('set text', 'all')
  }
}
</script>
