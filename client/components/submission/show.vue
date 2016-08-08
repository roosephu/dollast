<template lang="jade">
view
  .menu(slot="config")
    .ui.header links
    a.item(href="#!/user/{{submission.user}}")
      i.icon.user
      | Go to User
    a.item(href="#!/problem/{{submission.problem._id}}")
      i.icon.browser
      | Go to Problem
    a.item(href="#!/pack/{{submission.pack}}")
      i.icon.shopping.bag
      | Go to Pack

  .ui.basic.segment(:class="{loading: $loadingRouteData}", slot="main")
    h1.ui.header.dividing submissionution {{$route.params.sid}}
    .ui.olive.labels
      .ui.label {{submission.permit.owner}}
        .detail owner
      .ui.label {{submission.permit.group}}
        .detail group
      .ui.label {{submission.language}}
        .detail language
      .ui.label {{submission.problem._id}}
        .detail problem

    h2.ui.header.dividing code
    .ui.segment
      .ui.top.attached.label code
      pre.line-numbers
        code#code(:class="['language-' + submission.language]") {{submission.code}} 

    p(v-if="submission.summary.status == 'private'") this code is private
    .ui.segment(v-if="submission.summary.status == 'CE'")
      .ui.top.attached.label Error message
      pre {{submission.summary.message}}
    .ui(v-if="submission.summary.status == 'running'") running
    div(v-if="submission.summary.status == 'finished'")
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
            tr.positive(v-for="result in submission.results")
              td {{result.input}}
              td {{result.status}}
              td {{result.time | decimal 3}}
              td {{result.space | decimal 3}}
              td {{result.score | decimal 3}}
              td {{result.message}}
          tfoot
            tr
              th final result
              th {{submission.summary.status}}
              th {{submission.summary.time | decimal 3}}
              th {{submission.summary.space | decimal 3}}
              th {{submission.summary.score | decimal 3}}
              th {{submission.summary.message}}
</template>

<script>
require! {
  \debug
  \co
  \vue
  \prismjs : Prism
  \javascript-natural-sort : natural-sort
  \prismjs/components/prism-c
  \prismjs/components/prism-cpp
  \prismjs/themes/prism-solarizedlight.css
  \prismjs/plugins/line-numbers/prism-line-numbers
  \prismjs/plugins/line-numbers/prism-line-numbers.css
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
    submission:
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
      @submission.problem._id
    
    highlighted: ->
      if @submission.code != ""
        Prism.highlight @submission.code, Prism.languages[@submission.language]
      else
        ""

  route:
    data: co.wrap (to: params: {sid}) ->*
      {data: response} = yield vue.http.get "submission/#{sid}"
      if @check-response-errors response
        return null
      submission = response.data
      submission.results .= sort (a, b) ->
        natural-sort a.input, b.input

      {submission}
  
  watch:
    'submission.code': ->
      @$next-tick ->
        Prism.highlight-all!

</script>
