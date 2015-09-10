require! {
  \react/addons : R
  \../elements : E
  \../../stores/sess
}

module.exports = R.create-class do
  display-name: \login

  get-initial-state: ->
    uid: ""

  component-did-mount: ->
    $ '#login-form' .form do
      on: \blur
      fields:
        uid:
          identifier: \uid
          rules:
            * type: 'minLength[6]'
              prompt: "User name must be longer than 5"
            * type: 'maxLength[16]'
              prompt: "User name must be shorter than 15"
        pswd:
          identifier: \pswd
          rules:
            * type: 'minLength[6]'
              prompt: 'password length must be longer than 5'
            * type: 'maxLength[16]'
              prompt: 'password length must be shorter than 15'
      on-success: @submit
      debug: true

  submit: (e) ->
    e.prevent-default!
    $form = $ '#login-form'
    sess.actions.login $form.form 'get values'

  render: ->
    _div class-name: "ui",
      _h1 class-name: "ui dividing header", "Login"
      _form class-name: "ui form segment relaxed", id: "login-form",
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
        _ E.icon-text,
          class-name: "left primary labeled submit"
          icon: "sign in"
          text: \Login
        _div class-name: "ui error message"
