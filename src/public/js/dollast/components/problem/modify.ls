require! {
  \react/addons : {create-class}
  \react-redux : {connect}
  \immutable : I
  \../../actions : {on-update-problem, on-get-problem, on-upload-files}
  \../utils : {to-client-fmt}
  \../elements : {field, icon-text, label-field, dropdown}
  \react-dropzone : dropzone
}

log = debug 'dollast:component:problem:modify'

selector = (state) ->
  problem: state.get-in [\problem, \update], I.Map do
    outlook: 
      {}
    config:
      time-lmt: 1
      space-lmt: 512
      stk-lmt: 4
      out-lmt: 10
      dataset: []

module.exports = (connect selector) create-class do
  display-name: \prob-modify

  component-did-mount: ->
    $form = $ '#problem-modify'
    $form.form do
      on: \blur
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
    #log 'new states. setting new values for form...', to-client-fmt problem.to-JS!
    $form = $ '#problem-modify'
    $form.form 'set values', to-client-fmt problem.to-JS!

  component-will-update: (next-props, next-states) ->
    @update-forms next-props.problem
  
  on-drop: (files) ->
    @set-state files: files
  
  upload: ->
    files = @state.files
    if files
      @props.dispatch on-upload-files @state.pid, files
    
  render: ->
    problem = @props.problem.to-JS!
    problem-title = @props.problem.get-in [\outlook, \title]
    title = if @props.params.pid then "Update Problem #{that}. #{problem-title}" else "Create Problem"
    
    _div class-name: "ui form segment", id: 'problem-modify',
      _h1 class-name: "ui centered", title
      _div class-name: "ui error message"
      _div class-name: "ui three fields",
        _ label-field, class-name: "eight wide", text: \title,
          _div class-name: "ui input",
            _input name: \title
        _ label-field, class-name: "four wide", text: "round",
          _div class-name: "ui input",
            _input name: \rid, type: \number, placeholder: "optional"
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

      _div class-name: "ui four fields",
        _ label-field, text: "time limit (s)",
          _div class-name: "ui input",
            _input name: \timeLmt, type: \number
        _ label-field, text: "space limit (MB)",
          _div class-name: "ui input",
            _input name: \spaceLmt, type: \number
        _ label-field, text: "stack limit (MB)",
          _div class-name: "ui input",
            _input name: \stkLmt, type: \number
        _ label-field, text: "output limit (MB)",
          _div class-name: "ui input",
            _input name: \outLmt, type: \number

      _ field, null,
        _ label-field, text: \description
          _textarea name: \desc

      _div class-name: "ui two fields",
        _ label-field, text: "input format",
          _textarea name: \inFmt
        _ label-field, text: "output format",
          _textarea name: \outFmt
      _div class-name: "ui two fields",
        _ label-field, text: "sample input",
          _textarea name: \sampleIn
        _ label-field, text: "sample output",
          _textarea name: \sampleOut
          
      _div class-name: "ui divider"
      
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
      
      _div class-name: "ui two fields",
        _ field, class-name: "four wide",
          _ dropzone, on-drop: @on-drop,
            _div null,
              "drop files here for click to select"
        _ field, class-name: "twelve wide",
          _table class-name: "ui table segment",
            _thead null, 
              _tr null, 
                _th null, \input
                _th null, \output
                _th null, \weight
                _th null, ""
            _tbody null, 
              for atom in problem.config?.dataset
                _tr key: atom.input,
                  _td null, atom.input
                  _td null, atom.output
                  _td null, atom.weight
                  _td null,
                    _ icon-text,
                      class-name: "right floated mini"
                      icon: \remove
                      text: \remove
                      on-click: @remove

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