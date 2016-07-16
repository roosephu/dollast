<template lang="jade">
  .ui.basic.segment(:class="{loading: $loadingRouteData}")
    h1.ui.header.dividing Solution {{$route.params.sid}}
    .ui.olive.labels
      .ui.label {{sol.permit.owner}}
        .detail owner
      .ui.label {{sol.permit.group}}
        .detail group
      .ui.label {{sol.language}}
        .detail language
      .ui.label {{sol.problem._id}}
        .detail problem

    h2.ui.header.dividing code
    .ui.segment
      .ui.top.attached.label code
      pre {{sol.code}}

    p(v-if="sol.summary.status == 'private'") this code is private
    .ui.segment(v-if="sol.summary.status == 'CE'")
      .ui.top.attached.label Error message
      pre {{sol.summary.message}}
    .ui(v-if="sol.summary.status == 'running'") running
    div(v-if="sol.summary.status == 'finished'")
      .ui
        h1.ui.header.dividing details
        table.ui.table.segment
          thead
            tr
              th input
              th status
              th time
              th space
              th score
              th message
          tbody
            tr.positive(v-for="result in sol.results")
              td {{result.input}}
              td {{result.status}}
              td {{result.time}}
              td {{result.space}}
              td {{result.score}}
              td {{result.message}}
          tfoot
            tr
              th final result
              th {{sol.summary.status}}
              th {{sol.summary.time}}
              th {{sol.summary.space}}
              th {{sol.summary.score}}
              th {{sol.summary.message}}
</template>

<script lang="vue-livescript">
require! {
  \debug
  \co
  \vue
  \../../actions : {raise-error}
}

log = debug \dollast:component:submission:show

module.exports =
  vuex:
    actions:
      {raise-error}

  data: ->
    sol:
      summary: {}
      results: []
      problem:
        _id: 0
      permit:
        owner: ""
        group: ""

  computed:
    pid: ->
      @sol.prob._id

  route:
    data: co.wrap (to: params: {sid}) ->*
      {data: response} = yield vue.http.get "submission/#{sid}"
      if response.errors
        @raise-error response
        return null
      submission = response.data

      {sol: submission}

</script>
