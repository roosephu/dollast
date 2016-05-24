<template lang="jade">
  h1.ui.dividing.header Problem {{problem._id}}. {{problem.outlook.title}}
  .ui.segment(:class="{loading: $loadingRouteData}")
    .ui.olive.labels
      .ui.label {{problem.config.timeLmt}} s
        .detail time limit
      .ui.label {{problem.config.spaceLmt}} MB
        .detail space limit
      .ui.label {{problem.permit.owner}}
        .detail owner
      .ui.label {{problem.permit.group}}
        .detail group

    .ui.segment
      .ui.top.left.attached.label.teal description
      p(mathjax, v-html="problem.outlook.desc")
    .ui.two.column.grid
      .row
        .column
          .ui.segment
            .ui.top.left.attached.label.teal input format
            p(v-html="problem.outlook.inFmt")
        .column
          .ui.segment
            .ui.top.left.attached.label.teal output format
            p(v-html="problem.outlook.outFmt")
      .row
        .column
          .ui.segment
            .ui.top.left.attached.label.teal sample input
            pre {{problem.outlook.sampleIn}}
        .column
          .ui.segment
            .ui.top.left.attached.label.teal sample output
            pre {{problem.outlook.sampleOut}}

  .ui.header

  a.ui.icon.labeled.primary.button(href="#/solution/submit/{{problem._id}}")
    i.icon.rocket
    | submit
  a.ui.icon.labeled.button(href="#/problem/{{problem._id}}/modify")
    i.icon.edit
    | modify
  a.ui.icon.labeled.button(href="#/problem/{{problem._id}}/stat")
    i.icon.chart.bar
    | statistics
</template>

<script lang="vue-livescript">
require! {
  \co
  \debug
  \vue
}

log = debug \dollast:component:problem:show

module.exports =
  data: ->
    problem:
      config: {}
      outlook: {}
      permit: {}
  route:
    data: co.wrap (to: params: {pid}) ~>*
      {data} = yield vue.http.get "/problem/#{pid}"
      problem: data
  watch:
    'problem.outlook.desc': ->
      @$next-tick ~>
        MathJax.Hub.Queue [\Typeset, MathJax.Hub]

</script>
