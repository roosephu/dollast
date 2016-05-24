<template lang="jade">
  h1.ui.header.dividing Solution {{$route.params.sid}}
  .ui.olive.labels
    .ui.label {{sol.permit.owner}}
      .detail owner
    .ui.label {{sol.permit.group}}
      .detail group
    .ui.label {{sol.lang}}
      .detail language
    .ui.label {{sol.prob._id}}
      .detail problem

  h2.ui.header.dividing code
  .ui.segment
    .ui.top.attached.label code
    pre {{sol.code}}

  p(v-if="sol.final.status == 'private'") this code is private
  .ui.segment(v-if="sol.final.status == 'CE'")
    .ui.top.attached.label Error message
    pre {{sol.final.message}}
  .ui(v-if="sol.final.status == 'running'") running
  div(v-if="sol.final.status == 'finished'")
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
            th {{sol.final.status}}
            th {{sol.final.time}}
            th {{sol.final.space}}
            th {{sol.final.score}}
            th {{sol.final.message}}
</template>

<script lang="vue-livescript">
require! {
  \debug
  \co
  \vue
}

log = debug \dollast:component:solution:show

module.exports =
  data: ->
    sol:
      final: {}
      results: []
      prob:
        _id: 0
      permit:
        owner: ""
        group: ""

  computed:
    pid: ->
      @sol.prob._id

  route:
    data: co.wrap (to: params: {sid}) ->*
      {data} = yield vue.http.get "/solution/#{sid}"
      log {data}
      {sol: data}

</script>
