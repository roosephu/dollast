<template lang="jade">
view
  .ui.basic.segment(slot="main")
    h1.ui.dividing.header Login
    form.ui.form#login-form(:class="{loading: loading}")
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
  \../view
  \../../actions
}

log = debug 'dollast:component:login'

module.exports =
  vuex:
    actions:
      actions{login, raise-error}

  components:
    {view}

  data: ->
    success: false
    loading: false

  ready: ->
    $form = $ '#login-form'

    submit = co.wrap (e, values) ~>*
      e.prevent-default!
      @loading = true
      $form = $ '#login-form'
      {data} = yield vue.http.post \site/login, values
      @loading = false

      if data.errors
        $form.form 'add errors', [""]
        for error in data.errors
          $form.form 'add prompt', error.field, error.detail 
      else
        {data: {token}} = data
        local-storage.token = token
        @login token

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
              prompt: "User name must be shorter than 16"
        password:
          identifier: \password
          rules:
            * type: 'minLength[6]'
              prompt: 'password length must be longer than 5'
            * type: 'maxLength[16]'
              prompt: 'password length must be shorter than 16'
      on-success: submit
      debug: true
</script>
