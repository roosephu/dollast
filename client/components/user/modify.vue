<template lang="jade">
window
  .menu(slot="config")
    .ui.header links
    a.item(:href="'#!/user/' + user.profile._id")
      i.icon.user
      | Go to User

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
          .item(v-for="item in groups", :data-value="item") {{item}}

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

<script>
require! {
  \vuex : {default: {map-getters, map-actions}}
  \debug
  \../window
}

log = debug \dollast:components:user:modify

module.exports =

  components:
    {window}

  data: ->
    groups: [\problems, \submissions, \admin, \packs]
    user:
      profile:
        _id: ""
        groups: []

  methods: (map-actions [\$fetch]) <<<
    fetch: ->>
      @user = await @$fetch method: \GET, url: "user/#{@$route.params.user}"

  computed: (map-getters [\isLoading])

  mounted: ->
    @$next-tick ->
      $dropdown = $ \.ui.dropdown
      $dropdown.dropdown do
        allow-additions: true

      submit = (e) ~>>
        e.prevent-default!
        $form = $ '#form-user'
        {groups, old-password, new-password, confirm-password, description} = $form.form 'get values'
        groups = groups.split ','
        {_id} = @user.profile

        if old-password == "" or new-password == ""
          updated = {_id, groups, description}
        else
          updated = {_id, groups, description, old-password, new-password}

        await @$fetch method: \POST, url: "user/#{_id}", data: updated, form: $form

      $form = $ '#form-user'
      $form.form on-success: submit

  watch:
    'user.profile._id': ->
      $form = $ '#form-user'
      @$next-tick ~>
        $form.form 'set values', @user.profile{groups, description}

    $route: ->
      @fetch!

  created: ->
    @fetch!

</script>
