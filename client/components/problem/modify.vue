<template lang="jade">
  .ui.form.basic.segment#problem-modify
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
  \../../../common/judgers
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

    submit = co.wrap (e) ~>*
      e.prevent-default!
      problem = get-form-values!
      log {problem}
      {data} = yield @$http.post "problem", problem
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
        pack:
          identifier: \pack
          rules:
            * type: 'minLength[2]'
              prompt: 'pack id minimum length is 2'
            * type: 'maxLength[63]'
              prompt: 'pack id length cannot exceed 63'
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
        stack-limit:
          identifier: \stackLimit
          rules:
            * type: \positive
              prompt: "stack limit must be positive"
            ...
        output-lmt:
          identifier: \outputLimit
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
    if @problem == ""
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
