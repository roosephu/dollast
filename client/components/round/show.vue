<template lang="jade">
  h1.ui.dividing.header Round {{rnd._id}}. {{rnd.title}}

  .ui.olive.labels
    .ui.label {{rnd.permit.owner}}
      .detail owner
    .ui.label {{rnd.permit.group}}
      .detail group

  div from 
    .ui.label {{rnd.beginTime | time}} 
    | to 
    .ui.label {{rnd.endTime | time}}
  br

  div(v-if="started")
    h2.ui.dividing.header Problemset
    .ui.segment(:class="{loading: $loadingRouteData}")
      .ui.relaxed.divided.link.list
        .item(v-for="prob in rnd.problems")
          .ui.right.floated ??
          .description
            problem(:prob="prob")
    br

  div(v-else)
    h3.header Sorry, this round has not started.

  a.ui.icon.labeled.button(v-if="started", href="#/round/{{rnd._id}}/board")
    i.icon.trophy
    | board
  a.ui.icon.labeled.button(href="#/round/{{rnd._id}}/modify")
    i.icon.edit
    | modify
</template>

<script lang="vue-livescript">
require! {
  \vue
  \co
  \debug
  \moment
  \../format : {problem, formatter}
  \../../actions : {raise-error}
}

log = debug \dollast:component:round:show

module.exports =
  vuex:
    actions:
      {raise-error}

  components:
    {problem}

  data: ->
    rnd:
      begin-time: 0
      end-time: 0
      _id: 0
      problems: []
      permit:
        owner: ""
        group: ""

  computed:
    started: ->
      moment!.is-after @rnd.begin-time

  route:
    data: co.wrap (to: params: {rid}) ->*
      {data: response} = yield vue.http.get "round/#{rid}"
      if response.errors
        @raise-error response
        return null
      round = response.data

      {rnd: round}

</script>
