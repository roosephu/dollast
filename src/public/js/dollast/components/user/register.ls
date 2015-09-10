require! {
  \react/addons : R
  \../elements : E
  \../../stores/sess
}

module.exports = R.create-class do
  display-name: \register

  get-initial-state: ->
    uid: ""

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
    sess.actions.register all-values

  render: ->
    _div class-name: "ui",
      _h1 class-name: "ui dividing header", "Register"
      _form class-name: "ui form segment relaxed", id: "register-form",
        _ E.field, null,
          _ E.icon-input,
            class-name: "left"
            icon: \user
            input:
              placeholder: "user id"
              name: "uid"
        _ E.field, null,
          _ E.icon-input,
            class-name: "left"
            icon: \lock
            input:
              placeholder: \password
              name: "pswd"
              type: \password
        _div class-name: "field",
          _ E.icon-input,
            class-name: "left"
            icon: \mail
            input:
              placeholder: "abc@xyz"
              name: \email
              type: \email
        _ E.icon-text,
          class-name: "left primary labeled submit"
          icon: "sign in"
          text: \Register
        _div class-name: "ui error message"
