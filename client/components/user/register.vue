<template lang="jade">
  h1.ui.dividing.header Register
  form.ui.form.segment#register-form
    .ui.error.message
    .ui.success.message
      h2 Register successful. Login please.
    .ui.field
      a.ui.input.icon.left
        i.icon.user
        input(placeholder="user id", name="uid")
    .ui.field
      a.ui.input.icon.left
        i.icon.lock
        input(placeholder="password", name="pswd", type="password")
    .ui.field
      a.ui.input.icon.left
        i.icon.mail
        input(placeholder="abc@xyz", name="email", type="email")
    a.ui.icon.labeled.button.left.primary.submit
      i.icon.sign.in
      | Register
</template>

<script lang="vue-livescript">
require! {
  \debug
  \co
}

log = debug \dollast:component:login

module.exports =
  ready: ->
    submit = co.wrap (e) ~>*
      e.prevent-default!
      $form = $ '#register-form'
      all-values = $form.form 'get values'
      yield @$http.post \/user/register, all-values

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
      on-success: submit
      debug: true

</script>
