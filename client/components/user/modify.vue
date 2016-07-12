<template lang="jade">
  .ui.form#form-user
    h2.ui.dividing.header {{user.profile._id}}
    .ui.success.message
      .header Changes saved.

    .ui.field
      label groups
      .ui.dropdown.icon.selection.search.multiple
        input(type="hidden", name="groups")
        .default.text select proper access
        i.dropdown.icon
        .menu
          .item(v-for="item in groups", data-value="{{item}}") {{item}}

    h3.ui.dividing.header Description
    .ui.two.fields
      .ui.field
        label describe yourself
        textarea(name="desc")

    h3.ui.dividing.header Password
    .four.fields.wide
      .ui.field
        label old password
        .ui.icon.input.left
          i.icon.lock
          input(placeholder="old password", name="oldPassword", type="password")
    .four.fields.wide
      .ui.field
        label new password
        .ui.icon.input.left
          i.icon.lock
          input(placeholder="new  password", name="newPassword", type="password")
    .four.fields.wide
      .ui.field
        label confirm new password
        .ui.icon.input.left
          i.icon.lock
          input(placeholder="confirmation", name="confirmPassword", type="password")

    a.ui.icon.labeled.button.submit.primary
      i.icon.save
      | submit
</template>

<script lang="vue-livescript">
require! {
  \co
  \vue
  \debug
  \../../actions : {raise-error}
}

log = debug \dollast:components:user:modify

module.exports =
  vuex:
    actions:
      {raise-error}

  data: ->
    groups: [\problems, \solutions, \admin, \rounds]
    user:
      profile:
        _id: ""
        groups: []

  route:
    data: co.wrap (to: params: {uid}) ->*
      {data: response} = yield vue.http.get "user/#{uid}"
      if response.errors
        @raise-error response
        return null
      {data: user} = response 
      {user}

  ready: ->
    $dropdown = $ \.ui.dropdown
    $dropdown.dropdown do
      allow-additions: true

    submit = co.wrap (e) ~>*
      e.prevent-default!
      $form = $ '#form-user'
      {groups, old-password, new-password, confirm-password, desc} = $form.form 'get values'
      groups = groups.split ','
      {_id} = @user.profile

      if old-password == "" or new-password == ""
        updated = {_id, groups, desc}
      else
        updated = {_id, groups, desc, old-password, new-password}

      response = yield vue.http.post "user/#{_id}", updated
      # @props.dispatch on-update-user @props.params.uid, updated

    $form = $ '#form-user'
    $form.form do
      on-success: submit
      on: \blur
      inline: true
      fields:
        old-password:
          identifier: \oldPassword
          optional: true
          rules:
            * type: \isPassword
              prompt: "must be password"
            ...
        new-password:
          identifier: \newPassword
          optional: true
          rules:
            * type: \isPassword
              prompt: "must be password"
            ...
        confirmation:
          identifier: \confirmPassword
          optional: true
          rules:
            * type: \isPassword
              prompt: "must be password"
            * type: "match[newPassword]"
              prompt: "password must match"

  watch:
    'user.profile._id': ->
      $form = $ '#form-user'
      @$next-tick ~>
        $form.form 'set values', groups: @user.profile.groups, desc: @user.profile.desc

</script>
