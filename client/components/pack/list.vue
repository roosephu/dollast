<template lang="jade">
view
  .menu(slot="config")
    .item.icon#filter
      i.dropdown.icon
      i.icon.filter
      span Filter
      .menu
        .item(v-for="item in options", data-value="{{item}}")
          | {{item}}
    .divider
    a.item(href="#/pack/create")
      i.icon.plus 
      | Add a Pack

  .ui.basic.segment(:class="{loading: $loadingRouteData}", slot="main")
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

<script lang="livescript">
require! {
  \vue
  \debug
  \co
  \../format
  \../view
  \../../actions : {check-response-errors}
}

log = debug \dollast:component:pack:list

module.exports =
  vuex:
    actions:
      {check-response-errors}

  components:
    {view} <<< format{pack}

  data: ->
    options: {\All, \Past, \Running, \Pending}
    packs: []

  route:
    data: co.wrap ->*
      {data: response} = yield vue.http.get "pack"
      if @check-response-errors response
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
