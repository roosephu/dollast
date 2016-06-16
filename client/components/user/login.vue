<template lang="jade">
  .ui
    h1.ui.dividing.header Login
    form.ui.form.segment#login-form(:class="{loading: loading, success: success}")
      .ui.error.message
      .ui.success.message
        .header Login successfully. Redirect to problem list in 3 seconds.
      .ui.field
        .ui.icon.input.left
          i.icon.user
          input(name="uid", placeholder="user id")
      .ui.field
        .ui.icon.input.left
          i.icon.lock
          input(name="pswd", placeholder="password", type="password")
      .ui.icon.labeled.button.left.primary.submit
        i.icon.sign.in
        | Login
</template>

<script lang="vue-livescript">
require! {
  \debug
  \../../actions : {login}
}

log = debug 'dollast:component:login'

module.exports =
  vuex:
    actions:
      {login}

  data: ->
    success: false
    loading: false

  ready: ->
    $form = $ '#login-form'

    submit = co.wrap (e) ~>*
      e.prevent-default!
      $form = $ '#login-form'
      values = $form.form 'get values'
      {data} = yield vue.http.post \/site/login, values
      local-storage.token = data.payload.token
      @login data.payload.token

      @success = true

    $form.form do
      on: \blur
      inline: true
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
      on-success: submit
      debug: true

</script>
