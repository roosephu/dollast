<template lang="jade">
view
  .menu(slot="config")
    a.ui.icon.labeled.item(href="#/problem/{{problem._id}}/modify")
      i.icon.edit
      | Modify
    a.ui.icon.labeled.item(href="#/problem/{{problem._id}}/stat")
      i.icon.chart.bar
      | Statistics

  .ui.basic.segment(:class="{loading: $loadingRouteData}", slot="main")
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
          .ui.dropdown.icon.selection
            input(type="hidden", name="language")
            .default.text select your language
            i.dropdown.icon
            .menu
              .item(v-for="item in languages", data-value="{{item}}") {{item}}

      h2.ui.dividing.header permission
      .ui.four.fields
        .ui.field
          label owner
          .ui.input
            input(name="owner")
        .ui.field
          label group
          .ui.input
            input(name="group")
        .ui.field
          label access
          .ui.input
            input(name="access")

      h2.ui.dividing.header
      .ui.field
        a.icon.labeled.ui.button.primary.floated.submit
          i.icon.rocket
          | submit
</template>

<script lang="vue-livescript">
require! {
  \co
  \debug
  \vue
  \../view
  \../../actions : {raise-error}
}

log = debug \dollast:component:problem:show

module.exports =
  vuex:
    actions:
      {raise-error}
    getters:
      user: (.session.user)

  components:
    {view}

  data: ->
    languages: [\cpp, \java, \pas]
    problem:
      _id: 0
      config:
        pack:
          title: ""
      outlook: {}
      permit: {}

  computed:
    permit: ->
      owner: @user
      group: \submissions
      access: \rwxrw-r--

  route:
    data: co.wrap (to: params: {problem}) ->*
      {data: response} = yield vue.http.get "problem/#{problem}"
      if response.errors
        @raise-error response
        return null
      problem = response.data

      {problem}

  watch:
    'problem._id': ->
      @$next-tick ~>
        MathJax.Hub.Queue [\Typeset, MathJax.Hub]
      
  ready: ->
    $ '#viewpoint .ui.dropdown' .dropdown!
    submit = co.wrap (e) ~>*
      $form = $ '#submit-form'
      all-values = $form.form 'get values'
      permit = all-values{owner, group, access}

      data = Object.assign do
        all-values{code, language}
        {problem: @problem._id, permit}
      {data: response} = yield @$http.post \submission, data
      if response.errors
        errors = {}
        for error in response.errors
          Object.assign errors, error

        # TODO not working yet: https://github.com/Semantic-Org/Semantic-UI/issues/959
        # need to set the form to invalid state
        $form.form 'add errors', errors

    $form = $ '#submit-form'
    $form.form do
      on: \blur
      debug: true
      on-success: submit
      inline: true

    $form.form 'set values', @permit
</script>
