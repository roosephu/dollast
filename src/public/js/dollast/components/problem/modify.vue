<template lang="jade">
  .ui.form.segment#problem-modify
    h2.ui.dividing.header {{problem._id}}. {{problem.outlook.title}}
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
        label space limit (s)
        .ui.input
          input(name="spaceLmt", type="number")
      .ui.field
        label stack limit (s)
        .ui.input
          input(name="stkLmt", type="number")
      .ui.field
        label output limit (s)
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


    h3.ui.dividing.header Dataset Management
    .ui.field
      a.ui.icon.button.labeled(:click="select")
        i.icon.file
        | select
      a.ui.icon.button.labeled.green(:click="upload")
        i.icon.upload
        | upload
      a.ui.icon.button.labeled.teal(:click="refresh")
        i.icon.refresh
        | refresh
      a.ui.icon.button.labeled.teal(:click="repair")
        i.icon.retweet
        | repair

    .ui.two.fields
      .ui.field.four.wide dropzone
      .ui.field.twelve.wide
        table.ui.table.segment
          thead
            tr
              th input
              th output
              th weight
              th
          tbody
            tr(v-for="atom in problem.config.dataset")
              td {{atom.input}}
              td {{atom.output}}
              td {{atom.weight}}
              td
                a.ui.icon.labeled.button.right.floated.mini(:click="remove")
                  i.icon.remove
                  | remove

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
      .ui.icon.labeled.button.primary.floated.submit
        i.icon.save
        | Save
      .ui.icon.labeled.button.secondary.floated(href="#/problem/{{pid}}")
        i.icon.reply
        | Back
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
  permit.access      = parse-int permit.access, 8

  {outlook, config, permit}

set-form-values = (data) ->
  problem = flatten-object data
  $form = $ '#problem-modify'
  if problem.access
    problem.access .= to-string 8
  $form.form 'set values', problem

module.exports =
  data: ->
    pid: 0
    files: []
    judgers: [\string, \real, \strict, \custom]
    problem:
      outlook:
        title: 'hello world'
      config:
        dataset: []

  ready: ->
    $ \.dropdown .dropdown!

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
              prompt: 'access code should be /^[0-7]{3}$/'
            ...
      on-success:
        @submit

  route:
    data: co.wrap (to: params: {pid}) ~>*
      {data} = yield vue.http.get "/problem/#{pid}"
      set-form-values data
      {pid, problem: data}

  methods:
    repair: co.wrap ->*
      {data} = yield vue.http.get "/problem/#{@pid}/repair"

    upload: co.wrap ->*
      files = @files
      if files
        req = request \post, "/data/#{@pid}/upload"
        for f in files
          req.attach f.name, f
        {data} = yield req.end!

    submit: co.wrap (e) ->*
      e.prevent-default!
      problem = get-form-values!
      yield vue.http.post "/problem/#{@pid}", info

  render: ->
    problem = @props.problem.to-JS!
    problem-title = prob-fmt problem
    title = if @props.params.pid then "Update Problem #{problem-title}" else "Create Problem"

</script>
