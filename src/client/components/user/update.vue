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
import { mapActions, mapGetters } from "vuex"
import { debug } from "debug"
import window from '@/components/window'

const log = debug('dollast:components:user:modify')

export default {
  components: {
    window
  },

  data () {
    return {
      groups: ['problems', 'submissions', 'admin', 'rounds'],
      user: {
        profile: {
          _id: "",
          groups: []
        }
      }
    }
  },

  // methods: (map-actions [\$fetch]) <<<
  //   fetch: ->>
  //     @user = await @$fetch method: \GET, url: "user/#{@$route.params.user}"

  computed: {
    ...mapGetters(['isLoading'])
  },

  mounted () {
    this.$nextTick(() => {
      const $dropdown = $('.ui.dropdown')
      $dropdown.dropdown({ allowAdditions: true })

      const submit = async (e) => {
        e.preventDefault()
        const $form = $('#form-user')
        let { groups, oldPassword, newPassword, confirmPassword, description } = $form.form('get values')
        groups = groups.split(',')
        const { _id } = this.user.profile

        let updated
        if (oldPassword == "" || newPassword == "") {
          updated = { _id, groups, description }
        } else {
          updated = { _id, groups, description, oldPassword, newPassword }
        }

        // await @$fetch method: \POST, url: "user/#{_id}", data: updated, form: $form
      }

      const $form = $('#form-user')
      $form.form({ onSuccess: submit })
    })
  },

  watch: {
    'user.profile._id' () {
      const $form = $('#form-user')
      this.$nextTick(() => {
        const {groups, description} = this.user.profile
        $form.form('set values', {groups, description})
      })
    },

    $route () {
      // @fetch!
    }
  }

  // created: ->
  //   @fetch!
}
</script>
