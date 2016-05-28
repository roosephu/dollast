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
          input(name="timeLmt", type="number")
      .ui.field
        label space limit (MB)
        .ui.input
          input(name="spaceLmt", type="number")
      .ui.field
        label stack limit (MB)
        .ui.input
          input(name="stkLmt", type="number")
      .ui.field
        label output limit (MB)
        .ui.input
          input(name="outLmt", type="number")

    h3.ui.dividing.header Description
    .ui.field
      .ui.field
        label description
        textarea(name="desc")
    .ui.two.fields
      .ui.field
        label input format
        textarea(name="inFmt")
      .ui.field
        label output format
        textarea(name="outFmt")
    .ui.two.fields
      .ui.field
        label sample input
        textarea(name="sampleIn")
      .ui.field
        label sample output
        textarea(name="sampleOut")

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
  outlook = values{title, desc, in-fmt, out-fmt, sample-in, sample-out}
  config  = values{rid, pid, judger, time-lmt, space-lmt, out-lmt, stk-lmt}
  permit  = values{owner, group, access}
  if config.rid == ""
    delete config.rid
  else
    config.rid |>= parse-int

  config.time-lmt  |>= parse-float
  config.space-lmt |>= parse-float
  config.out-lmt   |>= parse-float
  config.stk-lmt   |>= parse-float

  {outlook, config, permit}

set-form-values = (data) ->
  problem = flatten-object data
  $form = $ '#problem-modify'
  $form.form 'set values', problem

module.exports =
  vuex:
    getters:
      uid: (.session.uid)

  data: ->
    pid: 0
    files: []
    judgers: [\string, \real, \strict, \custom]
    problem:
      _id: 0
      outlook:
        title: 'hello world'
      config:
        dataset: []

  computed:
    title: ->
      if @problem._id != 0
        "Problem #{@problem._id}. #{@problem.outlook.title}"
      else
        "Create new problem"

  ready: ->
    $ \.dropdown .dropdown!

    submit = co.wrap (e) ~>*
      e.prevent-default!
      problem = get-form-values!
      log {problem}
      yield @$http.post "/problem/#{@pid}", problem

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
          identifier: \timeLmt
          rules:
            * type: 'positive'
              prompt: 'time limit must be positive'
            ...
        space-lmt:
          identifier: \spaceLmt
          rules:
            * type: \positive
              prompt: 'space limit must be positive'
            ...
        stk-lmt:
          identifier: \stkLmt
          rules:
            * type: \positive
              prompt: "stack limit must be positive"
            ...
        out-lmt:
          identifier: \outLmt
          rules:
            * type: \positive
              prompt: "output limit must be positive"
            ...
        desc:
          identifier: \desc
          rules:
            * type: "maxLength[65535]"
              prompt: "description cannot be longer than 65535"
            ...
        in-fmt:
          identifier: \inFmt
          rules:
            * type: "maxLength[65535]"
              prompt: "input format cannot be longer than 65535"
            ...
        out-fmt:
          identifier: \outFmt
          rules:
            * type: "maxLength[65535]"
              prmopt: "output format cannot be longer than 65535"
            ...
        sample-in:
          identifier: \sampleIn
          rules:
            * type: "maxLength[65535]"
              prompt: "sample input cannot be longer than 65535"
            ...
        sample-out:
          identifier: \sampleOut
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
    if @pid == 0
      set-form-values do
        owner: @uid
        group: \problems
        access: \rwxrw-r--

  route:
    data: co.wrap (to: params: {pid}) ~>*
      if pid != void
        {data} = yield vue.http.get "/problem/#{pid}"
        set-form-values data
        {pid, problem: data}
</script>
