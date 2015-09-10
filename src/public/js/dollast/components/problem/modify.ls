require! {
  \co
  \react/addons : R
  \../utils : U
  \../elements : E
  \../../stores/problem
}

module.exports = R.create-class do
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
              prompt: 'minimum length is 2'
            * type: 'maxLength[63]'
              prompt: 'length cannot exceed 63'
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

    if @pid == 'create'
      co ->*
        @pid = yield problem.actions.next-count!
        console.log @pid

  submit: (e) ->
    e.prevent-default!
    $form = $ '#problem-modify'
    all-values = $form.form 'get values'
    problem.actions.update all-values <<<< {@pid}

  render: ->
    @pid = @props.params.pid
    @pid = "create" if !@pid
    _div class-name: "ui form segment", id: 'problem-modify',
      _h1 class-name: "ui centered", "problem: #{@pid}"
      _div class-name: "ui three fields",
        _ E.label-field, class-name: "eight wide", text: \title,
          _div class-name: "ui input",
            _input name: \title
        _ E.label-field, class-name: "four wide", text: "round",
          _div class-name: "ui input",
            _input name: \rid, type: \number, placeholder: "optional"
        _ E.label-field, class-name: "four wide", text: \judger,
          _ E.dropdown,
            name: \judger
            default: "Please choose a judger"
            options:
              string: \string
              real: \real
              strict: \strict
              custom: \custom

      _div class-name: "ui four fields",
        _ E.label-field, text: "time limit (s)",
          _div class-name: "ui input",
            _input name: \timeLmt, type: \number, default-value: 1
        _ E.label-field, text: "space limit (MB)",
          _div class-name: "ui input",
            _input name: \spaceLmt, type: \number, default-value: 512
        _ E.label-field, text: "stack limit (MB)",
          _div class-name: "ui input",
            _input name: \stkLmt, type: \number, default-value: 4
        _ E.label-field, text: "output limit (MB)",
          _div class-name: "ui input",
            _input name: \outLmt, type: \number, default-value: 10

      _ E.field, null,
        _ E.label-field, text: \description
          _textarea name: \desc

      _div class-name: "ui two fields",
        _ E.label-field, text: "input format",
          _textarea name: \inFmt
        _ E.label-field, text: "output format",
          _textarea name: \outFmt
      _div class-name: "ui two fields",
        _ E.label-field, text: "sample input",
          _textarea name: \sampleIn
        _ E.label-field, text: "sample output",
          _textarea name: \sampleOut

      _ E.field, null,
        _ E.icon-text,
          class-name: "primary floated submit"
          text: \Submit
          icon: \save
      _div class-name: "ui error message"
