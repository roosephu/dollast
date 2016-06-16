<template lang="jade">
  h1.ui.dividing.header Details of {{uid}}
  .ui.segment
    .ui.top.attached.label.large registered since
    p unimplemented

  .ui.segment
    .ui.large.top.attached.label description
    p {{profile.desc}}

  .ui.segment
    .ui.top.attached.label.large Groups
    .ui.olive.label(v-for="group in profile.groups") {{group}}

  .ui.segment
    .ui.top.attached.label.large Problems solved
    .ui.relaxed.divided.link.list
      .item(v-for="prob in solveProblems")
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
        .ui.right.floated {{rnd.begTime}} {{rnd.endTime}}
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

  route:
    data: co.wrap (to: params: {uid}) ->*
      {data: response} = yield vue.http.get "user/#{uid}"
      if response.errors
        @raise-error response
        return null
      profile = data.data

      profile

  components:
    format{problem, round}

</script>
