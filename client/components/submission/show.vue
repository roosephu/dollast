<template lang="jade">
view
  .menu(slot="config")
    a.item(href="#!/user/{{sol.user}}")
      i.icon.user
      | To User
    a.item(href="#!/problem/{{sol.problem._id}}")
      i.icon.browser
      | To Problem
    a.item(href="#!/pack/{{sol.pack}}")
      i.icon.shopping.bag
      | To Pack

  .ui.basic.segment(:class="{loading: $loadingRouteData}", slot="main")
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
      pre(:class="[sol.langauge]")#code {{sol.code}}

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
              td {{result.time | decimal 3}}
              td {{result.space | decimal 3}}
              td {{result.score | decimal 3}}
              td {{result.message}}
          tfoot
            tr
              th final result
              th {{sol.summary.status}}
              th {{sol.summary.time | decimal 3}}
              th {{sol.summary.space | decimal 3}}
              th {{sol.summary.score | decimal 3}}
              th {{sol.summary.message}}
</template>

<script lang="livescript">
require! {
  \debug
  \co
  \vue
  \../view
  \../../actions : {check-response-errors}
}

log = debug \dollast:component:submission:show

module.exports =
  vuex:
    actions: 
      {check-response-errors}

  components:
    {view}

  data: ->
    sol:
      code: ""
      summary: {}
      results: []
      problem:
        _id: 0
      permit:
        owner: ""
        group: ""

  computed:
    problem: ->
      @sol.problem._id

  route:
    data: co.wrap (to: params: {sid}) ->*
      {data: response} = yield vue.http.get "submission/#{sid}"
      if @check-response-errors response
        return null
      submission = response.data

      {sol: submission}
  
  watch:
    'sol.code': ->
      @$next-tick ->
        block = $ '#code' .0
        hljs.highlight-block block


</script>
