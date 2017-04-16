<template lang="jade">
window
  .menu(slot="config")
    .ui.header links
    router-link.item(:to="{name: 'submissions', query: {pack: pack._id}}")
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
    a.item(href="#/problem/create")
      i.icon.plus
      | Add a Problem
    a.item(:href="'#/pack/' + pack._id + '/board'")
      i.icon.trophy
      | Board
    a.item(:href="'#/pack/' + pack._id + '/modify'")
      i.icon.edit
      | Modify

  .ui.basic.segment(:class="{loading: isLoading}", slot="main")
    h1.ui.dividing.header Pack {{pack | pack}}

    .ui.olive.labels
      .ui.label {{pack.permit.owner}}
        .detail owner
      .ui.label {{pack.permit.group}}
        .detail group

    .ui.progress
      .bar
        .progress
      .label
        | from
        .ui.label {{pack.beginTime | time}}
        | to
        .ui.label {{pack.endTime | time}}

    .ui.header

    div(v-if="started")
      h2.ui.dividing.header Problemset
      .ui.very.relaxed.divided.link.list
        .item(v-for="prob in pack.problems")
          .ui.right.floated ??
          .description
            problem(:prob="prob")
      br

    div(v-else)
      h3.header Sorry, this pack has not started.
</template>

<script>
require! {
  \vuex : {default: {map-actions, map-getters}}
  \debug
  \moment
  \prelude-ls : {max}
  \../window
  \../format : {problem, formatter}
}

log = debug \dollast:component:pack:show

module.exports =

  components:
    {problem, window}

  data: ->
    options: [\All, \Failed, \Accepted, \New]
    pack:
      begin-time: 0
      end-time: 0
      _id: ''
      problems: []
      permit:
        owner: ""
        group: ""

  computed: (map-getters [\isLoading]) <<<
    started: ->
      moment!.is-after @pack.begin-time

  methods: (map-actions [\$fetch]) <<<
    fetch: ->>
      @pack = await @$fetch method: 'GET', url: "pack/#{@$route.params.pack}"

  watch:
    'pack._id': ->
      begin-time = moment @pack.begin-time
      end-time = moment @pack.end-time
      current = moment!
      $ \.ui.progress .progress do
        total: end-time - begin-time
        value: max(current - begin-time, 0)

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
      $filter.dropdown 'set text', \All

</script>
