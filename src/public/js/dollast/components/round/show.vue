<template lang="jade">
  h1.ui.dividing.header Round {{rnd._id}}. {{rnd.title}}
  p {{rnd.begTime}} -- {{rnd.endTime}}
  br

  div(v-if="rnd.started")
    h2.ui.dividing.header Problemset
    .ui.segment(:class="{loading: $loadingRouteData}")
      .ui.relaxed.divided.link.list
        .item(v-for="prob in rnd.probs")
          .ui.right.floated ??
          .description
            problem(:prob="prob")
    br

  div(v-else)
    p Sorry, this round has not started.

  a.ui.labeled.button.purple(v-if="rnd.started", href="#/round/{{rnd._id}}/board")
    i.icon.trophy
    | board
  a.ui.labeled.button.orange(href="#/round/{{rnd._id}}/modify")
    i.icon.edit
    | modify
</template>

<script lang="vue-livescript">
require! {
  \vue
  \co
  \debug
  \../format
}

log = debug \dollast:component:round:show

module.exports =
  components:
    format{problem}

  data: ->
    rnd:
      beg-time: 0
      end-time: 0
      _id: 0
      started: false
      probs: []

  route:
    data: co.wrap (to: params: {rid}) ->*
      {data} = yield vue.http.get "/round/#{rid}"
      {rnd: data}

</script>
