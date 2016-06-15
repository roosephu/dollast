require! {
  \react : {create-class}
  \react-redux : {connect}
  \../elements : {icon-text, icon-input}
  \../../actions : {on-register, on-set-ui}
  \classnames
}

log = debug 'dollast:component:login'

selector = (state) ->
  response: state.get-in [\db, \user, \register, \post], I.Map do
    type: \register
    payload: \success

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
            * type: 'isPassword'
              prompt: 'password length must be longer than 5'
            ...
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

  # component-will-update: (next-props, next-state) ->
  #   if next-props.

  render: ->
    classes = classnames "ui form segment" #, loading: true

    _ \div, class-name: "ui",
      _ \h1, class-name: "ui dividing header", "Register"
      _ \form, class-name: classes, id: "register-form",
        _ \div, class-name: "ui error message"
        _ \div, class-name: "ui success message",
          "Register successful. Login please."
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
