<template lang="jade">
view
  .ui.basic.segment(:class="{loading: $loadingRouteData}", slot="main")
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
    .ui.very.relaxed.divided.link.list#problems
      .item(v-for="problem in problems")
        .ui.right.floated ??
        .ui.description
          problem(:prob="problem")
</template>

<script lang="livescript">
require! {
  \vue
  \co
  \debug
  \../view
  \../format
  \../../actions : {check-response-errors}
}

log = debug \dollast:component:problem:list

module.exports =
  vuex:
    actions:
      {check-response-errors}

  data: ->
    filter: \all
    options: [\all, \solved, \unsolved]
    problems: []

  components:
    {view} <<< format{problem}

  route:
    data: co.wrap ->*
      {data: response} = yield vue.http.get \problem
      if @check-response-errors response
        return null
      problems = response.data

      {problems}

  ready: ->
    $filter = $ '.dropdown'
    $filter.dropdown do
      on: \hover
      on-change: (value) ~>
        @filter = value
    $filter.dropdown 'set text', \all

</script>
