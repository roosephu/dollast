<template lang="jade">
window
  form.ui.form.basic.segment(slot="main")#register-form
    h1.ui.dividing.header Register
    .ui.error.message
    .ui.success.message
      h2 Register successful. Login please.
    .ui.field
      a.ui.input.icon.left
        i.icon.user
        input(placeholder="user id", name="user")
    .ui.field
      a.ui.input.icon.left
        i.icon.lock
        input(placeholder="password", name="password", type="password")
    .ui.field
      a.ui.input.icon.left
        i.icon.mail
        input(placeholder="abc@xyz", name="email", type="email")
    a.ui.icon.labeled.button.left.primary.submit
      i.icon.sign.in
      | Register
</template>

<script>
require! {
  \debug
  \vue
  \vuex : {map-actions}
  \../window
}

log = debug \dollast:component:login

module.exports =
  components:
    {window}

  methods: map-actions [\$fetch]

  mounted: ->
    submit = (e) ~>>
      e.prevent-default!
      $form = $ '#register-form'
      all-values = $form.form 'get values'
      await @$fetch method: \POST, url: \user/register, data: all-values

    @$next-tick ->
      $ '#register-form' .form on-success: submit

</script>
