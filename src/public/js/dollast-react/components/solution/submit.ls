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
  permit:
    owner: state.get-in [\session, \uid]
    group: \solutions
    access: 8~644

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
        owner: \isUserId
        group: \isUserId
        access: \isAccess
      on-success: @submit
      inline: true
    $form.form 'set values', @props.permit{owner, group}
    $form.form 'set values', access: @props.permit.access.to-string 8

  submit: (e) ->
    e.prevent-default!
    $form = $ \#solution-submit
    all-values = $form.form 'get values'
    permit = all-values{owner, group, acces}
    permit.access = parse-int permit.access, 8

    data = Object.assign do
      pid: @props.params.pid
      uid: @props.uid
      all-values{code, lang}

    callback = ~>
      @props.history.push '#/solution'
    @props.dispatch on-submit-solution data, callback

  render: ->
    _ \div, class-name: "ui form segment relaxed", id: \solution-submit,
      _ field, null,
        _ \h1, class-name: "header divided", "problem: #{@props.params.pid}"
      _ \div, class-name: "ui success message",
        _ \div, class-name: "header",
          "Submit successful. Redirect to status in 3 seconds..."
      _ label-field, text: \code,
        _ \textarea, name: \code
      _ \div, class-name: "ui two fields",
        _ label-field, text: \language,
          _ dropdown,
            class-name: \selection
            name: \lang
            default: "please select your language"
            options: {\cpp, \pas, \java}

      _ \h2, class-name: "ui dividing header", \permission
      _ \div, class-name: "ui four fields",
        _ label-field, text: \owner,
          _ \div, class-name: "ui input",
            _ \input, name: \owner, type: \string
        _ label-field, text: \group,
          _ \div, class-name: "ui input",
            _ \input, name: \group, type: \string
        _ label-field, text: \access,
          _ \div, class-name: "ui input",
            _ \input, name: \access, type: \string

      _ \div, class-name: "ui field",
        _ icon-text,
          class-name: "primary floated submit"
          text: \Submit
          icon: \rocket
