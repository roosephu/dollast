<template lang="jade">
  h1.ui.dividing.header Round {{rnd._id}}. {{rnd.title}}

  .ui.olive.labels
    .ui.label {{rnd.permit.owner}}
      .detail owner
    .ui.label {{rnd.permit.group}}
      .detail group

  p {{rnd.beginTime}} -- {{rnd.endTime}}
  br

  div(v-if="started")
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

  a.ui.labeled.button.purple(v-if="started", href="#/round/{{rnd._id}}/board")
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
  \moment
  \../format
  \../../actions : {raise-error}
}

log = debug \dollast:component:round:show

module.exports =
  vuex:
    actions:
      {raise-error}

  components:
    format{problem}

  data: ->
    rnd:
      beg-time: 0
      end-time: 0
      _id: 0
      problems: []
      permit:
        owner: ""
        group: ""

  computed:
    started: ->
      moment!.is-after @rnd.beg-time

  route:
    data: co.wrap (to: params: {rid}) ->*
      {data: response} = yield vue.http.get "/round/#{rid}"
      if response.errors
        @raise-error response
        return null
      round = response.data

      {rnd: round}

</script>
