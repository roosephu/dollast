<template lang="jade">
  h1.ui.dividing.header Status
  .ui.segment(:class="{loading: false}")
    table.ui.table.large.green.selectable.very.basic
      thead
        tr
          th.collapsing.right sol id
          th problem
          th user
          th status
          th score
          th time(s)
          th space(MB)
          th.collapsing lang
          th.collapsing round
      tbody
        tr.red(v-for="sol in solutions")
          td
            code-link(:sid="sol._id")
          td
            problem(:prob="sol.problem")
          td
            user(:uid="sol.user")
          td {{sol.summary.status}}
          td {{sol.summary.score}}
          td {{sol.summary.time}}
          td {{sol.summary.space}}
          td {{sol.language}}
          td(v-if="sol.round")
            round(:rnd="sol.round")
          td(v-else)
  .ui.icon.labeled.button.floated.right.primary
    i.icon.refresh
    | refresh
</template>

<script lang="vue-livescript">
require! {
  \debug
  \co
  \vue
  \../format
  \../../actions : {raise-error}
}

log = debug \dollast:component:solution:list

module.exports =
  vuex:
    actions:
      {raise-error}

  data: ->
    solutions: []

  route:
    data: co.wrap ~>*
      {data: response} = yield vue.http.get \solution
      if response.errors
        @raise-error response
        return null
      solutions = response.data

      {solutions}

  components:
    format

</script>
