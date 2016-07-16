<template lang="jade">
  .ui.basic.segment(:class="{loading: $loadingRouteData}")
    h1.ui.dividing.header Details of {{uid}}
    .ui.segment
      .ui.top.attached.label.large registered since
      p {{registerDate}}

    .ui.segment
      .ui.large.top.attached.label description
      p {{profile.description}}

    .ui.segment
      .ui.top.attached.label.large Groups
      .ui.olive.label(v-for="group in profile.groups") {{group}}

    .ui.segment
      .ui.top.attached.label.large Problems solved
      .ui.relaxed.divided.link.list
        .item(v-for="prob in solvedProblems")
          .description
            problem(:prob="prob")

    .ui.segment
      .ui.top.attached.label.large Problems owned
      .ui.relaxed.divided.link.list
        .item(v-for="prob in ownedProblems")
          .description
            problem(:prob="prob")

    .ui.segment
      .ui.top.attached.label.large Rounds owned
      .ui.relaxed.divided.link.list
        .item(v-for="rnd in ownedRounds")
          .ui.right.floated 
            .ui.label {{rnd.beginTime | time}}
            | to  
            .ui.label {{rnd.endTime | time}}
          .description
            round(:rnd="rnd")

    a.ui.button.icon.labeled.text.primary(href="#/user/{{uid}}/modify")
      i.icon.edit
      | modify
</template>

<script lang="vue-livescript">
require! {
  \vue
  \co
  \moment
  \debug
  \../format
  \../../actions : {raise-error}
}

log = debug \dollast:components:user:profile

module.exports =
  vuex:
    actions:
      {raise-error}

  data: ->
    uid: @$route.params.uid
    profile: {}
    solved-problems: []
    owned-problems: []
    owned-rounds: []
  
  computed:
    register-date: ->
      if @profile.date
        moment @profile.date .format 'MMMM Do YYYY'
      else
        ""

  route:
    data: co.wrap (to: params: {uid}) ->*
      {data: response} = yield vue.http.get "user/#{uid}"
      if response.errors
        @raise-error response
        return null
      profile = response.data

      profile

  components:
    format{problem, round}

</script>
