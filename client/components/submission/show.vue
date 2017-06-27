<template lang="jade">
window
  .menu(slot="config")
    .ui.header links
    a.item(:href="'#!/user/' + submission.user")
      i.icon.user
      | Go to User
    a.item(:href="'#!/problem/' + submission.problem._id")
      i.icon.browser
      | Go to Problem
    a.item(:href="'#!/round/' + submission.round")
      i.icon.shopping.bag
      | Go to Round

  .ui.basic.segment(:class="{loading: isLoading}", slot="main")
    h1.ui.header.dividing Submission {{$route.params.sid}}
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
    h2.ui(v-if="submission.summary.status == 'running'") running
    h2.ui(v-if="submission.summary.status == 'hidden'") hidden
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

<script lang="livescript">
require! {
  \debug
  \vuex : {default: {map-getters, map-actions}}
  \prismjs : Prism
  \javascript-natural-sort : natural-sort
  \prismjs/components/prism-c
  \prismjs/components/prism-cpp
  \prismjs/themes/prism-solarizedlight.css
  \prismjs/plugins/line-numbers/prism-line-numbers
  \prismjs/plugins/line-numbers/prism-line-numbers.css
  \../window
}

log = debug \dollast:component:submission:show

module.exports =

  components:
    {window}

  data: ->
    submission:
      code: ""
      summary: {}
      results: []
      problem:
        _id: "0"
      permit:
        owner: ""
        group: ""

  computed: (map-getters [\isLoading]) <<<
    problem: ->
      @submission.problem._id

    highlighted: ->
      if @submission.code != ""
        Prism.highlight @submission.code, Prism.languages[@submission.language]
      else
        ""

  methods: (map-actions [\$fetch]) <<<
    fetch: ->>
      submission = await @$fetch method: \GET, url: "submission/#{@$route.params.sid}"
      submission.results .= sort (a, b) ->
        natural-sort a.input, b.input
      @ <<< {submission}

  watch:
    'submission.code': ->
      @$next-tick ->
        Prism.highlight-all!

    $route: ->
      @fetch!

  created: ->
    @fetch!

</script>
