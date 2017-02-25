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
    a.item(href="#/pack/create")
      i.icon.plus
      | Add a Pack

  .ui.basic.segment(:class="{loading: isLoading}", slot="main")
    h1.ui.header.dividing Packs

    .ui.very.relaxed.divided.link.list
      .item(v-for="pack in packs")
        .ui.right.floated
          .ui.label {{pack.beginTime | time}}
          | to
          .ui.label {{pack.endTime | time}}
        .description
          pack(:pack="pack")
</template>

<script>
require! {
  \vue
  \vuex : {map-actions, map-getters}
  \debug
  \../format
  \../window
}

log = debug \dollast:component:pack:list

module.exports =
  components:
    {window} <<< format{pack}

  data: ->
    options: {\All, \Past, \Running, \Pending}
    packs: []

  computed: map-getters [\isLoading]

  methods: (map-actions [\$fetch]) <<<
    fetch: ->>
      @packs = await @$fetch method: 'GET', url: "pack"

  watch:
    $route: ->
      @fetch!

  created: ->
    @fetch!

  mounted: ->
    @$next-tick ->
      $ '#configuration' .dropdown do
        on: \hover

      $filter = $ '#filter'
      $filter.dropdown do
        on-change: (value, text, $choice) ->
          log {value, text, $choice}
      $filter.dropdown 'set text', \all

</script>
