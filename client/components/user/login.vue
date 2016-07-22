<template lang="jade">
  .ui.basic.segment
    h1.ui.dividing.header Login
    form.ui.form.segment#login-form(:class="{loading: loading, success: success}")
      .ui.error.message
      .ui.success.message
        .header Login successfully. Redirect to problem list in 3 seconds.
      .ui.field
        .ui.icon.input.left
          i.icon.user
          input(name="user", placeholder="user id")
      .ui.field
        .ui.icon.input.left
          i.icon.lock
          input(name="password", placeholder="password", type="password")
      .ui.icon.labeled.button.left.primary.submit
        i.icon.sign.in
        | Login
</template>

<script lang="vue-livescript">
require! {
  \debug
  \co
  \vue
  \../../actions
}

log = debug 'dollast:component:login'

module.exports =
  vuex:
    actions:
      actions{login, raise-error}

  data: ->
    success: false
    loading: false

  ready: ->
    $form = $ '#login-form'

    submit = co.wrap (e) ~>*
      e.prevent-default!
      $form = $ '#login-form'
      values = $form.form 'get values'
      {data} = yield vue.http.post \site/login, values
      if data.errors
        @raise-error data, true
      else
        {data: {token}} = data
        local-storage.token = token
        @login token

      @success = true

    $form.form do
      on: \blur
      inline: true
      fields:
        user:
          identifier: \user
          rules:
            * type: 'minLength[6]'
              prompt: "User name must be longer than 5"
            * type: 'maxLength[16]'
              prompt: "User name must be shorter than 15"
        password:
          identifier: \password
          rules:
            * type: 'minLength[6]'
              prompt: 'password length must be longer than 5'
            * type: 'maxLength[16]'
              prompt: 'password length must be shorter than 15'
      on-success: submit
      debug: true

</script>
