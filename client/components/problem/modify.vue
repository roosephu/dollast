<template lang="jade">
view
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
        .ui.dropdown.icon.selection.fluid.search#pack
          input(type="hidden", name="pack")
          .default.text pack
          i.dropdown.icon
          .menu
            .item(data-value="{{pack._id}}") {{pack | pack}}
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
        textarea(name="description")
    .ui.two.fields
      .ui.field
        label input format
        textarea(name="inputFormat")
      .ui.field
        label output format
        textarea(name="outputFormat")
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
      .ui.icon.labeled.button.secondary(href="#/problem/{{problem}}")
        i.icon.reply
        | Back
      a.ui.icon.labeled.button.secondary(v-if="problem != 0", href="#/problem/{{problem}}/data")
        i.icon.archive
        | Dataset Manage
</template>

<script lang="vue-livescript">
require! {
  \debug
  \co
  \vue
  \flat
  \../view
  \../elements/permit
  \../../actions : {raise-error}
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
  if data?.config?.pack?._id
    data.config.pack .= _id
  problem = flatten-object data
  $form = $ '#problem-modify'
  $form.form 'set values', problem

module.exports =
  vuex:
    getters:
      user: (.session.user)
    actions:
      {raise-error}

  components:
    {view, permit}

  data: ->
    pack: 
      _id: ""
      title: ""
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
    $ \.dropdown .dropdown!

    $pack = $ '#pack'
    # log {$dropdown}
    $pack.dropdown do
      data-type: \jsonp
      api-settings:
        save-remove-data: false
        on-response: (response) ->
          if !response.data?._id
            return success: false, results: []
          # log {response}
          pack = response.data
          {_id, title} = pack
          return results: [value: _id, name: vue.filter(\pack) pack]
        url: "/api/pack/{query}/"
        on-change: (value) ~>
          log {value}

    submit = co.wrap (e, values) ~>*
      e.prevent-default!
      problem = get-form-values values
      log {problem}
      {data} = yield @$http.post "problem", problem
      if data.errors
        $form = $ '#problem-modify'
        $form.form 'add errors', [""]
        for error in data.errors
          $form.form 'add prompt', error.field, error.detail 

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
        if response.errors
          @raise-error response
          return null
        problem = response.data
        {pack} = problem.config

        {problem, pack}
  
  watch:
    'problem._id': ->
      @$next-tick ->
        $ '#pack' .dropdown \refresh
        set-form-values @problem

</script>
