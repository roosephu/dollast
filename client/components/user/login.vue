<template lang="jade">
window
  .ui.basic.segment(slot="main")
    h1.ui.dividing.header Login
    form.ui.form#login-form(:class="{loading: isLoading}")
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

<script>
require! {
  \debug
  \vuex : {default: {map-getters, map-actions}}
  \../window
}

log = debug 'dollast:component:login'

module.exports =

  components:
    {window}

  computed: map-getters [\isLoading]

  methods: (map-actions [\$fetch, \login]) <<<
    fetch: (values, form) ->>
      {token} = await @$fetch form: form, method: \POST, url: \site/login, data: values

  data: ->
    success: false

  mounted: ->
    @$next-tick ->
      $form = $ '#login-form'
      submit = (e, values) ~>>
        e.prevent-default!
        await @fetch method: \POST, url: \site/login, data: values, form: $form

      $form.form on-success: submit

</script>
