require! {
  \react : {create-class}
  \react-redux : {connect}
  \immutable : {from-JS}
  \../../actions : {on-update-problem, on-get-problem, on-upload-files, on-repair-problem}
  \../utils : {to-client-fmt}
  \../elements : {field, icon-text, label-field, dropdown}
  \../format : {prob-fmt}
  \react-dropzone : dropzone
}

log = debug 'dollast:component:problem:modify'

selector = (state, props) ->
  problem: state.get-in [\db, \problem, props.params.pid, \get], from-JS do
    loading: true
    outlook:
      {}
    config:
      time-lmt: 1
      space-lmt: 512
      stk-lmt: 4
      out-lmt: 10
      dataset: []
      judger: \string
    permit:
      owner: state.get-in [\session, \uid]
      group: \problems
      access: 8~644
  status: state.get-in [\status, \problem, props.params.pid, \get], \init
  # response: state.get-in [\db, \problem, props.params.pid, \post], I.Map do
  #

module.exports = (connect selector) create-class do
  display-name: \prob-modify

  component-did-mount: ->
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
    if @props.params.pid
      @props.dispatch on-get-problem @props.params.pid, \update, \total
    pid = if @props.params.pid then parse-int that else 0
    @set-state {pid}
    #@update-forms @props.problem

  submit: (e) ->
    e.prevent-default!
    $form = $ '#problem-modify'
    all-values = $form.form 'get values'

    @props.dispatch on-update-problem @state.pid, all-values

  update-forms: (problem) ->
    # log 'new states. setting new values for form...', problem.to-JS!
    problem = to-client-fmt problem.to-JS!
    $form = $ '#problem-modify'
    if problem.access
      problem.access .= to-string 8
    $form.form 'set values', problem

  component-will-update: (next-props, next-states) ->
    @update-forms next-props.problem

  on-drop: (files) ->
    # @set-state files:

  repair: ->
    # log \repairing
    @props.dispatch on-repair-problem @state.pid

  upload: ->
    files = @state.files
    if files
      @props.dispatch on-upload-files @state.pid, files

  render: ->
    problem = @props.problem.to-JS!
    problem-title = prob-fmt problem
    title = if @props.params.pid then "Update Problem #{problem-title}" else "Create Problem"

    _ \div, class-name: "ui form segment", id: 'problem-modify',
      _ \h1, class-name: "ui centered", title
      _ \div, class-name: "ui error message"

      _ \h2, class-name: "ui dividing header", \configuration
      _ \div, class-name: "ui three fields",
        _ label-field, class-name: "eight wide", text: \title,
          _ \div, class-name: "ui input",
            _ \input, name: \title
        _ label-field, class-name: "four wide", text: "round",
          _ \div, class-name: "ui input",
            _ \input, name: \rid, type: \number, placeholder: "optional"
        _ label-field, class-name: "four wide", text: \judger,
          _ dropdown,
            class-name: \selection
            name: \judger
            default: "Please choose a judger"
            options:
              string: \string
              real: \real
              strict: \strict
              custom: \custom

      _ \div, class-name: "ui four fields",
        _ label-field, text: "time limit (s)",
          _ \div, class-name: "ui input",
            _ \input, name: \timeLmt, type: \number
        _ label-field, text: "space limit (MB)",
          _ \div, class-name: "ui input",
            _ \input, name: \spaceLmt, type: \number
        _ label-field, text: "stack limit (MB)",
          _ \div, class-name: "ui input",
            _ \input, name: \stkLmt, type: \number
        _ label-field, text: "output limit (MB)",
          _ \div, class-name: "ui input",
            _ \input, name: \outLmt, type: \number

      _ \h2, class-name: "ui dividing header", \description
      _ field, null,
        _ label-field, text: \description
          _ \textarea, name: \desc

      _ \div, class-name: "ui two fields",
        _ label-field, text: "input format",
          _ \textarea, name: \inFmt
        _ label-field, text: "output format",
          _ \textarea, name: \outFmt
      _ \div, class-name: "ui two fields",
        _ label-field, text: "sample input",
          _ \textarea, name: \sampleIn
        _ label-field, text: "sample output",
          _ \textarea, name: \sampleOut

      _ \h2, class-name: "ui dividing header", "dataset management"
      _ field, null,
        _ icon-text,
          icon: \file
          text: \select
          on-click: @select
        _ icon-text,
          class-name: \green
          icon: \upload
          text: \upload
          on-click: @upload
        _ icon-text,
          class-name: \teal
          icon: \refresh
          text: \refresh
          on-click: @refresh
        _ icon-text,
          class-name: \purple
          icon: \retweet
          text: \repair
          on-click: @repair

      _ \div, class-name: "ui two fields",
        _ field, class-name: "four wide",
          _ dropzone, on-drop: @on-drop,
            _ \div, class-name: "ui segment",
              "drop files here for click to select"
        _ field, class-name: "twelve wide",
          _ \table, class-name: "ui table segment",
            _ \thead, null,
              _ \tr, null,
                _ \th, null, \input
                _ \th, null, \output
                _ \th, null, \weight
                _ \th, null, ""
            _ \tbody, null,
              for atom in problem.{}config.[]dataset
                _ \tr, key: atom.input,
                  _ \td, null, atom.input
                  _ \td, null, atom.output
                  _ \td, null, atom.weight
                  _ \td, null,
                    _ icon-text,
                      class-name: "right floated mini"
                      icon: \remove
                      text: \remove
                      on-click: @remove

      _ \h2, class-name: "ui dividing header", \permission
      _ \div, class-name: "ui four fields",
        _ label-field, text: \owner,
          _ \div, class-name: "ui input",
            _ \input, name: \owner
        _ label-field, text: \group,
          _ \div, class-name: "ui input",
            _ \input, name: \group
        _ label-field, text: \access,
          _ \div, class-name: "ui input",
            _ \input, name: \access

      _ field, null,
        _ icon-text,
          class-name: "primary floated submit"
          text: \Save
          icon: \save
        _ icon-text,
          class-name: "secondary floated"
          text: \Back
          icon: \reply
          href: "#/problem/#{@props.params.pid}"
