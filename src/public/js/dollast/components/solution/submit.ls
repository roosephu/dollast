require! {
  \react : {create-class}
  \react-redux : {connect}
  \../../actions : {on-submit-solution}
  \../elements : {field, label-field, dropdown, icon-text}
  \immutable : I
}

log = debug \dollast:component:solution:submit

selector = (state) ->
  uid: state.get-in [\session, \uid], "guest"

module.exports = (connect selector) create-class do
  display-name: \sol-submit

  component-did-mount: ->
    $form = $ '#solution-submit'
    $form.form do
      on: \blur
      fields:
        code:
          identifier: \code
          rules:
            * type: 'minLength[4]'
              prompt: 'code minimum length is 4'
            * type: 'maxLength[65535]'
              prompt: 'code length cannot exceed 65535'
        lang:
          identifier: \lang
          rules:
            * type: 'empty'
              prompt: 'language cannot be empty'
            ...
      on-success: @submit

  submit: (e) ->
    e.prevent-default!
    $form = $ \#solution-submit
    all-values = $form.form 'get values'

    data = all-values <<<< pid: @props.params.pid, uid: @props.uid
    @props.dispatch on-submit-solution data

  render: ->
    _ \div, class-name: "ui form segment relaxed", id: \solution-submit,
      _ field, null,
        _ \h1, class-name: "header divided", "problem: #{@props.params.pid}"
      _ \div, class-name: "ui error message"
      _ label-field, text: \code,
        _ \textarea, name: \code
      _ \div, class-name: "ui two fields",
        _ label-field, text: \language,
          _ dropdown,
            class-name: \selection
            name: \lang
            default: "please select your language"
            options:
              cpp: \cpp
              pas: \pas
              java: \java
      _ field, null,
        _ icon-text,
          class-name: "primary floated submit"
          text: \Submit
          icon: \rocket
