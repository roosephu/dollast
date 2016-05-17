<template lang="jade">
  .ui.form.segment.relaxed#submit-form
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
          input(type="hidden", name="lang")
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
      a.ui.icon.labeled.button.primary.floated.submit
        i.icon.rocket
        | Submit
</template>

<script lang="vue-livescript">
require! {
  \vue
  \debug
  \co
}

log = debug \dollast:components:solution:submit

module.exports =
  vuex:
    getters:
      session: (.session)

  data: ->
    pid: @$route.params.pid
    languages: [\cpp, \java, \pas]

  computed:
    permit: ->
      owner: @session.uid
      group: \solutions
      access: 8~644

  ready: ->
    $ \.dropdown .dropdown!
    submit = co.wrap (e) ->*
      e.prevent-default!
      $form = $ \#solution-submit
      all-values = $form.form 'get values'
      permit = all-values{owner, group, acces}
      permit.access = parse-int permit.access, 8

      data = Object.assign do
        pid: @props.params.pid
        uid: @props.uid
        all-values{code, lang}
      yield vue.http.post \/solution/submit, data

    $form = $ '#submit-form'
    $form.form do
      on: \blur
      fields:
        code:
          identifier: \code
          rules:
            * type: 'minLength[4]'
              prompt: 'code minimum length is 4'
            * type: 'maxLength[65535]'
              prompt: 'code length cannot exceed 65535'
        lang:
          identifier: \lang
          rules:
            * type: 'empty'
              prompt: 'language cannot be empty'
            ...
        owner: \isUserId
        group: \isUserId
        access: \isAccess
      on-success: submit
      inline: true

    # $form.form 'set values', @permit{owner, group}
    # $form.form 'set values', access: @permit.access.to-string 8


</script>
