<template lang="jade">
window
  .menu(slot="config")
    .ui.header links
    router-link.item(:to="{name: 'submissions', query: {user: user}}")
      i.icon
      | All submissions
    .ui.divider
    .ui.header operations
    a.item(:href="'#/user/' + user + '/modify'")
      i.icon.edit
      | Modify

  .ui.basic.segment(:class="{loading: isLoading}", slot="main")
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
      .ui.top.attached.label.large Rounds owned
      .ui.relaxed.divided.link.list
        .item(v-for="round in ownedRounds")
          .ui.right.floated
            .ui.label {{round.beginTime | time}}
            | to
            .ui.label {{round.endTime | time}}
          .description
            round(:round="round")
</template>

<script lang="livescript">
require! {
  \vuex : {default: {map-actions, map-getters}}
  \moment
  \debug
  \javascript-natural-sort : natural-sort
  \../window
  \../format
}

log = debug \dollast:components:user:profile

natural-sort-by = (f) ->
  (a, b) ->
    a |>= f
    b |>= f
    natural-sort a, b

module.exports =

  data: ->
    user: @$route.params.user
    profile: {}
    solved-problems: []
    owned-problems: []
    owned-rounds: []

  computed: (map-getters [\isLoading]) <<<
    register-date: ->
      if @profile.date
        moment @profile.date .format 'MMMM Do YYYY'
      else
        ""

  created: ->
    @fetch!

  watch:
    $route: ->
      @fetch!

  methods: (map-actions [\$fetch]) <<<
    fetch: ->>
      profile = await @$fetch method: \GET, url: "user/#{@$route.params.user}"
      profile.solved-problems .= sort natural-sort-by (._id)
      profile.owned-problems .= sort natural-sort-by (._id)
      profile.owned-rounds .= sort natural-sort-by (._id)

      @ <<< {profile}

  components:
    {window} <<< format{problem, round}

</script>
