<template lang="jade">
  h3.ui.header author: {{user}}
  h3.ui.header lang: {{lang}}
  h3.ui.header problem: {{prob._id}}

  h1.ui.header.dividing code
  pre {{code}}

  p(v-if="final.status == 'private'") this code is private
  .ui.segment(v-if="final.status == 'CE'")
    .ui.top.attached.label Error message
    pre {{final.message}}
  .ui(v-if="final.status == 'running'") running
  div(v-if="final.status == 'finished'")
    .ui.toggle.checkbox
      input(type="checkbox")
      label Current state: {{state}}
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
          tr.positive(v-for="result in results")
            td {{result.input}}
            td {{result.status}}
            td {{result.time}}
            td {{result.space}}
            td {{result.score}}
            td {{result.message}}
        tfoot
          tr
            th final result
            th {{final.status}}
            th {{final.time}}
            th {{final.space}}
            th {{final.score}}
            th {{final.message}}
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
    final: {}
    results: []
    prob:
      _id: 0

  computed:
    pid: ->
      @prob._id

  route:
    data: co.wrap (to: params: {sid}) ->*
      {data} = yield vue.http.get "/solution/#{sid}"
      log {data}
      data

</script>
