require! {
  \react : {create-class}
  \react-redux : {connect}
  \../elements : {icon-text, icon-input}
  \../../actions : {on-register}
}

log = debug 'dollast:component:login'

module.exports = connect! create-class do
  display-name: \register

  component-did-mount: ->
    $ '#register-form' .form do
      on: \blur
      fields:
        uid:
          identifier: \uid
          rules:
            * type: 'minLength[3]'
              prompt: "User name must be longer than 5"
            * type: 'maxLength[16]'
              prompt: "User name must be shorter than 15"
        pswd:
          identifier: \pswd
          rules:
            * type: 'minLength[3]'
              prompt: 'password length must be longer than 5'
            * type: 'maxLength[16]'
              prompt: 'password length must be shorter than 15'
        email:
          identifier: \email
          rules:
            * type: 'email'
              prompt: 'please enter a valid email address'
            ...
      on-success: @submit
      debug: true

  submit: (e) ->
    e.prevent-default!
    $form = $ '#register-form'
    all-values = $form.form 'get values'
    @props.dispatch on-register all-values

  render: ->
    _ \div, class-name: "ui",
      _ \h1, class-name: "ui dividing header", "Register"
      _ \form, class-name: "ui form segment relaxed", id: "register-form",
        _ \div, class-name: "ui field",
          _ icon-input,
            class-name: "left"
            icon: \user
            input:
              placeholder: "user id"
              name: "uid"
        _ \div, class-name: "ui field",
          _ icon-input,
            class-name: "left"
            icon: \lock
            input:
              placeholder: \password
              name: "pswd"
              type: \password
        _ \div, class-name: "field",
          _ icon-input,
            class-name: "left"
            icon: \mail
            input:
              placeholder: "abc@xyz"
              name: \email
              type: \email
        _ icon-text,
          class-name: "left primary labeled submit"
          icon: "sign in"
          text: \Register
        _ \div, class-name: "ui error message"
