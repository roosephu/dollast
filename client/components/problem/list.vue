<template lang="jade">
  .ui
    h1.ui.dividing.header Problem List
    .ui.dropdown.floated.pointing.button.labeled.icon
      input(type="hidden", name="filter")
      .default.text please select filter
      i.dropdown.icon
      .menu
        .item(v-for="item in options", data-value="{{item}}") {{item}}
    a.ui.icon.labeled.button.right.floated.primary(href="#/problem/create")
      i.icon.plus
      | create
    .ui.segment
      .ui.very.relaxed.divided.link.list
        .item(v-for="prob in problems")
          .ui.right.floated ??
          .ui.description
            problem(:prob="prob")
</template>

<script lang="vue-livescript">
require! {
  \vue
  \co
  \debug
  \../format/problem
}

log = debug 'dollast:component:problem:list'

module.exports =
  data: ->
    filter: \all
    options: [\all, \solved, \unsolved]
    problems: []

  components:
    {problem}

  created: ->
    co ~>*
      {data: @problems} = yield vue.http.get \/problem

  ready: ->
    $filter = $ '.dropdown'
    $filter.dropdown do
      on: \hover
      on-change: (value) ~>
        @filter = value
    $filter.dropdown 'set text', \all

</script>
