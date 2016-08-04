<template lang="jade">
view
  .ui.basic.segment.form(slot="main")#form-user
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
        textarea(name="description")

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

<script lang="livescript">
require! {
  \co
  \vue
  \debug
  \../view
  \../../actions : {raise-error}
}

log = debug \dollast:components:user:modify

module.exports =
  vuex:
    actions:
      {raise-error}

  components:
    {view}

  data: ->
    groups: [\problems, \submissions, \admin, \packs]
    user:
      profile:
        _id: ""
        groups: []

  route:
    data: co.wrap (to: params: {user}) ->*
      {data: response} = yield vue.http.get "user/#{user}"
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
      {groups, old-password, new-password, confirm-password, description} = $form.form 'get values'
      groups = groups.split ','
      {_id} = @user.profile

      if old-password == "" or new-password == ""
        updated = {_id, groups, description}
      else
        updated = {_id, groups, description, old-password, new-password}

      response = yield vue.http.post "user/#{_id}", updated
      # @props.dispatch on-update-user @props.params.user, updated

    $form = $ '#form-user'
    $form.form on-success: submit

  watch:
    'user.profile._id': ->
      $form = $ '#form-user'
      @$next-tick ~>
        $form.form 'set values', @user.profile{groups, description}

</script>
