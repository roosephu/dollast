require! {
  \react : {create-class}
  \react-redux : {connect}
  \../elements : {field, icon-text, icon-input}
  \../../actions : {on-login}
  \classnames
  \immutable : {from-JS}
}

log = debug 'dollast:component:login'

selector = (state) ->
  user: state.get-in [\db, \site, \login, \post], from-JS do
    status: \init

module.exports = (connect selector) create-class do
  display-name: \login

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
    @props.dispatch on-login $form.form 'get values'

  render: ->
    user = @props.user.to-JS!
    classes = classnames "ui form segment",
      loading: user.status == \wait
      success: user.payload?.token? && user.status == \done
      # error:

    _ \div, class-name: "ui",
      _ \h1, class-name: "ui dividing header", "Login"
      _ \form, class-name: classes, id: "login-form",
        _ \div, class-name: "ui error message"
        _ \div, class-name: "ui success message",
          "Login successfully."
        _ field, null,
          _ icon-input,
            class-name: "left"
            icon: \user
            input:
              placeholder: "user id"
              name: "uid"
        _ field, null,
          _ icon-input,
            class-name: "left"
            icon: \lock
            input:
              placeholder: \password
              name: "pswd"
              type: \password
        _ icon-text,
          class-name: "left primary labeled submit"
          icon: "sign in"
          text: \Login
