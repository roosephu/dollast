<template lang="jade">
  .ui.basic.segment(:class="{loading: $loadingRouteData}")
    h1.ui.header.dividing Packs

    .ui.icon.top.left.dropdown.pointing.button.primary#configuration
      i.icon.wrench
      .menu
        .item#filter
          i.dropdown.icon
          i.icon.filter
          span Filter
          .menu
            .item(v-for="item in options", data-value="{{item}}")
              | {{item}}
        .divider
        a.item(href="#/pack/create")
          i.icon.plus 
          | Create a new pack

    .ui.very.relaxed.divided.link.list
      .item(v-for="pack in packs")
        .ui.right.floated 
          .ui.label {{pack.beginTime | time}} 
          | to 
          .ui.label {{pack.endTime | time}}
        .description
          pack(:pack="pack")
</template>

<script lang="vue-livescript">
require! {
  \vue
  \debug
  \co
  \../format
  \../../actions : {raise-error}
}

log = debug \dollast:component:pack:list

module.exports =
  components:
    format{pack}

  data: ->
    options: {\all, \past, \running, \pending}
    showing: \all
    packs: []

  route:
    data: co.wrap ->*
      {data: response} = yield vue.http.get "pack"
      if response.errors
        @raise-error response
        return null
      packs = response.data

      {packs}

  ready: ->
    $ '#configuration' .dropdown do
      on: \hover 

    $filter = $ '#filter'
    $filter.dropdown do
      on-change: (value, text, $choice) ->
        log {value, text, $choice}
    $filter.dropdown 'set text', \all

</script>
