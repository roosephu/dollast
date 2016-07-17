<template lang="jade">
  .ui.basic.segment(:class="{loading: $loadingRouteData}")
    h1.ui.header.dividing Rounds
    .ui.dropdown.floated.pointing.button.labeled.icon
      input(type="hidden", name="filter")
      .default.text please select filter
      i.dropdown.icon
      .menu
        .item(v-for="item in options", data-value="{{item}}") {{item}}
    a.ui.icon.labeled.button.launch.primary.right.floated(href="#/round/create")
      i.icon.plus
      | create
    .ui.segment
      .ui.very.relxed.divided.link.list
        .item(v-for="round in rounds")
          .ui.right.floated 
            .ui.label {{round.beginTime | time}} 
            | to 
            .ui.label {{round.endTime | time}}
          .description
            round(:rnd="round")
</template>

<script lang="vue-livescript">
require! {
  \vue
  \debug
  \co
  \../format
  \../../actions : {raise-error}
}

log = debug \dollast:component:round:list

module.exports =
  components:
    format{round}

  data: ->
    options: {\all, \past, \running, \pending}
    rounds: []

  route:
    data: co.wrap ->*
      {data: response} = yield vue.http.get "round"
      if response.errors
        @raise-error response
        return null
      rounds = response.data

      {rounds}

  ready: ->
    $filter = $ '.dropdown'
    # log $filter
    $filter.dropdown do
      on: \hover
      on-change: (value, text, $choice) ->
        log {value, text, $choice}
    $filter.dropdown 'set text', \all

</script>
