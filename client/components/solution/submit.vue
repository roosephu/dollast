<template lang="jade">
  .ui.form.segment#submit-form
    h1.ui.header.dividing problem: {{pid}}
    .ui.success.message
      .header Submit successful. Redirect to status in 3 seconds...
    .ui.field
      label code
      textarea(name="code")
    .ui.two.fields
      .ui.field
        label language
        .ui.dropdown.icon.selection
          input(type="hidden", name="language")
          .default.text select your language
          i.dropdown.icon
          .menu
            .item(v-for="item in languages", data-value="{{item}}") {{item}}

    h2.ui.dividing.header permission
    .ui.four.fields
      .ui.field
        label owner
        .ui.input
          input(name="owner")
      .ui.field
        label group
        .ui.input
          input(name="group")
      .ui.field
        label access
        .ui.input
          input(name="access")

    .ui.field
      a.ui.button.primary.floated.submit
        //- i.icon.rocket
        | Submit
</template>

<script lang="vue-livescript">
require! {
  \debug
  \co
  \prelude-ls : {pairs-to-obj, obj-to-pairs, flatten}
}

log = debug \dollast:components:solution:submit

module.exports =
  vuex:
    getters:
      uid: (.session.uid)

  data: ->
    pid: parse-int @$route.params.pid
    languages: [\cpp, \java, \pas]

  computed:
    permit: ->
      owner: @uid
      group: \solutions
      access: \rwxrw-r--

  ready: ->
    $ \.dropdown .dropdown!
    submit = co.wrap (e) ~>*
      $form = $ '#submit-form'
      all-values = $form.form 'get values'
      permit = all-values{owner, group, access}

      data = Object.assign do
        all-values{code, language}
        {@pid, permit}
      {data: response} = yield @$http.post \solution/submit, data
      if response.errors
        errors = {}
        for error in response.errors
          Object.assign errors, error

        # TODO not working yet: https://github.com/Semantic-Org/Semantic-UI/issues/959
        # need to set the form to invalid state
        $form.form 'add errors', errors

    $form = $ '#submit-form'
    $form.form do
      on: \blur
      debug: true
      fields:
        code:
          identifier: \code
          rules:
            * type: 'minLength[4]'
              prompt: 'code minimum length is 4'
            * type: 'maxLength[65535]'
              prompt: 'code length cannot exceed 65535'
        lang:
          identifier: \language
          rules:
            * type: 'empty'
              prompt: 'language cannot be empty'
            ...
        owner:
          identifier: \owner
          rules:
            * type: \isUserId
              prompt: 'wrong user id'
            ...
        group:
          identifier: \group
          rules:
            * type: \isUserId
              prompt: 'wrong group id'
            ...
        access:
          identifier: \access
          rules:
            * type: \isAccess
              prompt: 'wrong access code'
            ...
      on-success: submit
      inline: true

    $form.form 'set values', @permit


</script>
