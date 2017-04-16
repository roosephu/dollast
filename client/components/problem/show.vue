<template lang="jade">
window
  .menu(slot="config")
    .ui.header links
    a.ui.icon.labeled.item(:href="'#/problem/' + problem._id + '/stat'")
      i.icon.chart.bar
      | Statistics
    a.item(:href="'#/pack/' + problem.config.pack._id")
      i.icon.shopping.bag
      | Go to Pack
    router-link.ui.icon.labeled.item(:to="{name: 'submissions', query: {problem: problem._id}}")
      i.icon
      | All Submissions
    .ui.divider
    .ui.header operations
    a.ui.icon.labeled.item(:href="'#/problem/' + problem._id + '/modify'")
      i.icon.edit
      | Modify

  .ui.basic.segment(:class="{loading: isLoading}", slot="main")
    h1.ui.dividing.header Problem {{problem._id}}. {{problem.outlook.title}}
    .ui.olive.labels
      .ui.label {{problem.config.timeLimit}} s
        .detail time limit
      .ui.label {{problem.config.spaceLimit}} MB
        .detail space limit
      .ui.label {{problem.permit.owner}}
        .detail owner
      .ui.label {{problem.permit.group}}
        .detail group
      .ui.label {{problem.config.pack | pack}}
        .detail pack

    .ui.segment
      .ui.top.left.attached.label.teal description
      p(mathjax, v-html="problem.outlook.description")
    .ui.two.column.grid
      .row
        .column
          .ui.segment
            .ui.top.left.attached.label.teal input format
            p(v-html="problem.outlook.inputFormat")
        .column
          .ui.segment
            .ui.top.left.attached.label.teal output format
            p(v-html="problem.outlook.outputFormat")
      .row
        .column
          .ui.segment
            .ui.top.left.attached.label.teal sample input
            pre {{problem.outlook.sampleInput}}
        .column
          .ui.segment
            .ui.top.left.attached.label.teal sample output
            pre {{problem.outlook.sampleOutput}}

    .ui.header

    .ui.form#submit-form
      .ui.success.message
        .header Submit successful. Redirect to status in 3 seconds...
      h2.ui.dividing.header Submission
      .ui.field
        label code
        textarea(name="code")
      .ui.two.fields
        .ui.field
          label language
          .ui.dropdown.icon.selection#languages
            input(type="hidden", name="language")
            .default.text select your language
            i.dropdown.icon
            .menu
              .item(v-for="item in languages", :data-value="item") {{item}}

      permit.hello

      h2.ui.dividing.header
      .ui.field
        a.icon.labeled.ui.button.primary.floated.submit
          i.icon.rocket
          | submit
</template>

<script>
require! {
  \debug
  \vuex : {default: {map-actions, map-getters}}
  \../window
  \../elements/permit
}

log = debug \dollast:component:problem:show

module.exports =

  components:
    {window, permit}

  data: ->
    languages: [\cpp, \java, \pas]
    problem:
      _id: 0
      config:
        pack:
          title: ""
      outlook: {}
      permit: {}

  computed: (map-getters [\isLoading]) <<<
    permit: ->
      owner: @user
      group: \submissions
      access: 'rwxrw-r--'

  methods: (map-actions [\$fetch]) <<<
    fetch: ->>
      @problem = await @$fetch method: \GET, url: "problem/#{$route.params.problem}"

  created: ->
    @fetch!

  watch:
    'problem._id': ->
      @$next-tick ~>
        if MathJax?
          MathJax.Hub.Queue [\Typeset, MathJax.Hub]

    $route: ->
      @fetch!

  mounted: ->
    @$next-tick ->
      submit = (e, values) ~>>
        $form = $ '#submit-form'
        permit = values{owner, group, access}

        data = {problem: @problem._id, permit} <<<< values{code, language}
        await @$fetch method: \POST, url: \submission, data: data

      $form = $ '#submit-form'
      $form.form do
        on-success: submit
        on: \submit
      $form.form 'set values', @permit
      $ '#languages' .dropdown!
</script>
