<template lang="jade">
view
  .menu(slot="config")
    .ui.header Links
    a.item(href="#/problem/{{problem._id}}")
      i.icon.reply
      | Go to Problem
    .ui.divider
    .ui.header Operations 
    .item(v-if="problem._id != ''", @click="remove")
      i.icon.cancel
      | Delete
    a.item(v-if="problem._id != ''", href="#/problem/{{problem._id}}/data")
      i.icon.archive
      | Dataset Manage

  .ui.form.basic.segment(slot="main")#problem-modify
    h2.ui.dividing.header {{title}}
    .ui.error.message

    h3.ui.dividing.header Configuration
    .ui.three.fields
      .ui.field.twelve.wide
        label title
        .ui.input
          input(name="title")
      .ui.field.four.wide
        label pack id
        pack-selector#pack(:pack="pack")
    .ui.field
      label judger
      .ui.dropdown.icon.fluid.selection#judger
        input(type="hidden", name="judger")
        .default.text choose a judger
        i.dropdown.icon
        .menu
          .item(v-for="(key, value) of judgers", data-value="{{key}}") ({{key}}) {{value}}

    .ui.four.fields
      .ui.field
        label time limit (s)
        .ui.input
          input(name="timeLimit", type="number")
      .ui.field
        label space limit (MB)
        .ui.input
          input(name="spaceLimit", type="number")
      .ui.field
        label stack limit (MB)
        .ui.input
          input(name="stackLimit", type="number")
      .ui.field
        label output limit (MB)
        .ui.input
          input(name="outputLimit", type="number")

    h3.ui.dividing.header Description
    .ui.field
      .ui.field
        label description
        textarea#description(name="description")
    .ui.two.fields
      .ui.field
        label input format
        textarea#inputFormat(name="inputFormat")
      .ui.field
        label output format
        textarea#outputFormat(name="outputFormat")
    .ui.two.fields
      .ui.field
        label sample input
        textarea(name="sampleInput")
      .ui.field
        label sample output
        textarea(name="sampleOutput")

    permit

    .ui.field
      .ui.icon.labeled.button.primary.submit
        i.icon.save
        | Save
</template>

<script>
require! {
  \debug
  \co
  \vue
  \flat
  \../view
  \../elements/permit
  \../elements/pack-selector
  \../../actions : {check-response-errors}
  \../../../common/judgers
}

log = debug 'dollast:component:problem:modify'

flatten-object = (obj) ->
  ret = {}
  for key, val of obj
    if 'object' == typeof val
      ret <<< flatten-object val
    else
      ret[key] = val
  ret

get-form-values = (values) ->
  outlook = values{title, description, input-format, output-format, sample-input, sample-output}
  config  = values{pack, problem, judger, time-limit, space-limit, output-limit, stack-limit}
  permit  = values{owner, group, access}

  config.time-limit   |>= parse-float
  config.space-limit  |>= parse-float
  config.output-limit |>= parse-float
  config.stack-limit  |>= parse-float

  {outlook, config, permit}

set-form-values = (data) ->
  problem = flatten-object data
  if data.config?.pack?._id
    problem.pack = data.config.pack._id
  $form = $ '#problem-modify'
  $form.form 'set values', problem

module.exports =
  vuex:
    getters:
      user: (.session.user)
    actions:
      {check-response-errors}

  components:
    {view, permit, pack-selector}

  methods:
    remove: co.wrap ->*
      {data: response} = yield @$http.delete "problem/#{@problem._id}"
      if not @check-response-errors response
        @$route.router.go "/pack/#{@problem.config.pack._id}"

  data: ->
    pack: void
    judgers: judgers
    problem:
      _id: ""
      outlook:
        title: 'hello world'
      config:
        dataset: []
        pack:
          _id: ""
          title: ""

  computed:
    title: ->
      if @problem._id != ""
        "Problem #{@problem._id}. #{@problem.outlook.title}"
      else
        "Create new problem"

  ready: ->
    CKEDITOR.replace \description
    CKEDITOR.replace \inputFormat
    CKEDITOR.replace \outputFormat

    @$next-tick ->
      $ '#judger' .dropdown!

    submit = co.wrap (e, values) ~>*
      e.prevent-default!
      description = CKEDITOR.instances.description.get-data!
      input-format = CKEDITOR.instances.inputFormat.get-data!
      output-format = CKEDITOR.instances.outputFormat.get-data!

      problem = get-form-values values <<<< {description, input-format, output-format}
      if @problem._id != ""
        problem._id = @problem._id

      log {problem}
      {data: response} = yield @$http.post "problem", problem
      if not @check-response-errors response, $ '#problem-modify'
        if @problem._id == ""
          @$route.router.go path: "problem/#{response._id}/modify"

    $form = $ '#problem-modify'
    $form.form on-success: submit
    if @problem._id == ""
      set-form-values do
        owner: @user
        group: \problems
        access: \rwxrw-r--

  route:
    data: co.wrap (to: params: {problem}) ->*
      if problem != void
        {data: response} = yield vue.http.get "problem/#{problem}"
        if @check-response-errors response
          return null
        problem = response.data
        {pack} = problem.config

        {problem, pack}
  
  watch:
    'problem._id': ->
      @$next-tick ->
        set-form-values @problem

</script>
