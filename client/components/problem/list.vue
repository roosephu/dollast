<template lang="jade">
window
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
          problem(:prob="problem")
</template>

<script>
require! {
  \vue
  \vuex : {map-getters, map-actions}
  \debug
  \../window
  \../format
}

log = debug \dollast:component:problem:list

module.exports =

  data: ->
    filter: \all
    options: [\all, \solved, \unsolved]
    problems: []

  components:
    {window} <<< format{problem}

  computed: map-getters [\isLoading]

  created: ->
    @fetch!

  watch:
    $route: ->
      @fetch!

  methods: (map-actions [\$fetch]) <<<
    fetch: ->>
      @problem = await @$fetch method: \GET, url: \problem

  mounted: ->
    $filter = $ '.dropdown'
    $filter.dropdown do
      on: \hover
      on-change: (value) ~>
        @filter = value
    $filter.dropdown 'set text', \all

</script>
