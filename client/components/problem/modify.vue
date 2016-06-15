<template lang="jade">
  .ui.form#problem-modify
    h2.ui.dividing.header {{title}}
    .ui.error.message

    h3.ui.dividing.header Configuration
    .ui.three.fields
      .ui.field.eight.wide
        label title
        .ui.input
          input(name="title")
      .ui.field.four.wide
        label round
        .ui.input
          input(name="rid", type="number", placeholder="optional")
      .ui.field.four.wide
        label judger
        .ui.dropdown.icon.selection
          input(type="hidden", name="judger")
          .default.text choose a judger
          i.dropdown.icon
          .menu
            .item(v-for="item in judgers", data-value="{{item}}") {{item}}

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
          input(name="stkLimit", type="number")
      .ui.field
        label output limit (MB)
        .ui.input
          input(name="outLimit", type="number")

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

    h3.ui.dividing.header Permission
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

    .ui.field
      .ui.icon.labeled.button.primary.submit
        i.icon.save
        | Save
      .ui.icon.labeled.button.secondary(href="#/problem/{{pid}}")
        i.icon.reply
        | Back
      a.ui.icon.labeled.button.secondary(v-if="pid != 0", href="#/problem/{{pid}}/data")
        i.icon.archive
        | Dataset Manage
</template>

<script lang="vue-livescript">
require! {
  \debug
  \co
  \vue
  \../../actions : {raise-error}
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

get-form-values = ->
  values = $ '.form' .form 'get values'
  outlook = values{title, description, input-format, output-format, sample-input, sample-output}
  config  = values{rid, pid, judger, time-limit, space-limit, out-limit, stk-limit}
  permit  = values{owner, group, access}
  if config.rid == ""
    delete config.rid
  else
    config.rid |>= parse-int

  config.time-limit  |>= parse-float
  config.space-limit |>= parse-float
  config.out-limit   |>= parse-float
  config.stk-limit   |>= parse-float

  {outlook, config, permit}

set-form-values = (data) ->
  problem = flatten-object data
  $form = $ '#problem-modify'
  $form.form 'set values', problem

module.exports =
  vuex:
    getters:
      uid: (.session.uid)
    actions:
      {raise-error}

  data: ->
    pid: ""
    files: []
    judgers: [\string, \real, \strict, \custom]
    problem:
      _id: ""
      outlook:
        title: 'hello world'
      config:
        dataset: []

  computed:
    title: ->
      if @problem._id != ""
        "Problem #{@problem._id}. #{@problem.outlook.title}"
      else
        "Create new problem"

  ready: ->
    $ \.dropdown .dropdown!

    submit = co.wrap (e) ~>*
      e.prevent-default!
      problem = get-form-values!
      log {problem}
      if @pid == ""
        {data} = yield @$http.post "/problem", problem
      else
        {data} = yield @$http.put "/problem/#{@pid}", problem
      if data.errors != void
        log data.errors

    $form = $ '#problem-modify'
    $form.form do
      on: \blur
      inline: true
      fields:
        title:
          identifier: \title
          rules:
            * type: 'minLength[2]'
              prompt: 'title minimum length is 2'
            * type: 'maxLength[63]'
              prompt: 'title length cannot exceed 63'
        rid:
          identifier: \rid
          optional: true
          rules:
            * type: 'integer[1..]'
              prompt: '#rid must be a positive integer'
            ...
        judger:
          identifier: \judger
          rules:
            * type: 'empty'
              prompt: 'please choose your judger'
            ...
        time-lmt:
          identifier: \timeLimit
          rules:
            * type: 'positive'
              prompt: 'time limit must be positive'
            ...
        space-lmt:
          identifier: \spaceLimit
          rules:
            * type: \positive
              prompt: 'space limit must be positive'
            ...
        stk-lmt:
          identifier: \stkLimit
          rules:
            * type: \positive
              prompt: "stack limit must be positive"
            ...
        out-lmt:
          identifier: \outLimit
          rules:
            * type: \positive
              prompt: "output limit must be positive"
            ...
        desc:
          identifier: \description
          rules:
            * type: "maxLength[65535]"
              prompt: "description cannot be longer than 65535"
            ...
        in-fmt:
          identifier: \inputFormat
          rules:
            * type: "maxLength[65535]"
              prompt: "input format cannot be longer than 65535"
            ...
        out-fmt:
          identifier: \outputFormat
          rules:
            * type: "maxLength[65535]"
              prmopt: "output format cannot be longer than 65535"
            ...
        sample-in:
          identifier: \sampleInput
          rules:
            * type: "maxLength[65535]"
              prompt: "sample input cannot be longer than 65535"
            ...
        sample-out:
          identifier: \sampleOutput
          rules:
            * type: "maxLength[65535]"
              prompt: "sample output cannot be longer than 65535"
            ...
        owner:
          identifier: \owner
          rules:
            * type: \isUserId
              prompt: 'owner should be valid'
            ...
        group:
          identifier: \group
          rules:
            * type: \isUserId
              prompt: 'group should be valid'
            ...
        access:
          identifier: \access
          rules:
            * type: \isAccess
              prompt: 'access code should be /^([r-][w-][x-]){3}$/'
            ...
      on-success:
        submit
    if @pid == ""
      set-form-values do
        owner: @uid
        group: \problems
        access: \rwxrw-r--

  route:
    data: co.wrap (to: params: {pid}) ~>*
      if pid != void
        {data: response} = yield vue.http.get "/problem/#{pid}"
        if response.errors
          @raise-error response
          return null
        problem = response.data

        set-form-values problem
        {pid, problem}
</script>
