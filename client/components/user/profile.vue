<template lang="jade">
view
  .menu(slot="config")
    a.item(href="#/user/{{user}}/modify")
      i.icon.edit
      | Modify
    a.item(v-link="{name: 'submissions', query: {user: user}}")
      i.icon
      | All submissions

  .ui.basic.segment(:class="{loading: $loadingRouteData}", slot="main")
    h1.ui.dividing.header Details of {{user}}
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
      .ui.top.attached.label.large Packs owned
      .ui.relaxed.divided.link.list
        .item(v-for="pack in ownedPacks")
          .ui.right.floated 
            .ui.label {{pack.beginTime | time}}
            | to  
            .ui.label {{pack.endTime | time}}
          .description
            pack(:pack="pack")
</template>

<script>
require! {
  \vue
  \co
  \moment
  \debug
  \../view
  \../format
  \../../actions : {check-response-errors}
}

log = debug \dollast:components:user:profile

module.exports =
  vuex:
    actions:
      {check-response-errors}

  data: ->
    user: @$route.params.user
    profile: {}
    solved-problems: []
    owned-problems: []
    owned-packs: []
  
  computed:
    register-date: ->
      if @profile.date
        moment @profile.date .format 'MMMM Do YYYY'
      else
        ""

  route:
    data: co.wrap (to: params: {user}) ->*
      {data: response} = yield vue.http.get "user/#{user}"
      if @check-response-errors response
        return null
      profile = response.data

      profile

  components:
    {view} <<< format{problem, pack}

</script>
