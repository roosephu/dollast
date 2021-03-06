<template lang="jade">
Window
  .menu(slot="config")
    .ui.header links
    RouterLink.item(:to="'/user/' + user._id")
      i.icon.user
      | Go to User

  .ui.basic.segment.form(slot="main")#form-user
    h2.ui.dividing.header {{user._id}}
    .ui.success.message
      .header Changes saved.

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
          input(placeholder="new password", name="password", type="password")
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
import { mapGetters } from 'vuex'
import { debug } from 'debug'
import Window from '@/components/Window'
import gql from 'graphql-tag'

const log = debug('dollast:components:user:modify')

export default {
  components: {
    Window
  },

  data () {
    return {
      groups: ['problems', 'submissions', 'admin', 'rounds'],
      user: {
        _id: ''
      }
    }
  },

  apollo: {
    user: {
      query: gql`query ($_id: ID!) {
        user(_id: $_id) {
          _id
          description
        }
      }`,
      variables () {
        return {
          _id: this.$route.params.userId
        }
      }
    }
  },

  computed: {
    ...mapGetters(['isLoading'])
  },

  mounted () {
    this.$nextTick(() => {
      const $dropdown = $('.ui.dropdown')
      $dropdown.dropdown({ allowAdditions: true })

      const submit = async (e, values) => {
        e.preventDefault()
        let { oldPassword, password, description } = values
        // groups = groups.split(',')
        const { _id } = this.user

        let updated
        if (oldPassword === '' || password === '') {
          updated = { _id, description }
        } else {
          updated = { _id, description, oldPassword, password }
        }

        await this.$apollo.mutate({
          mutation: gql`mutation ($_id: ID!, $password: String, $oldPassword: String, $description: String) {
            updateUser(_id: $_id, password: $password, oldPassword: $oldPassword, description: $description) {
              _id
            }
          }`,
          variables: updated
        })
      }

      const $form = $('#form-user')
      $form.form({
        onSuccess: submit,
        fields: {
          oldPassword: { optional: true, rules: [{ type: 'isPassword' }] },
          password: { depends: 'oldPassword', rules: [{ type: 'isPassword' }] },
          confirmPassword: { depends: 'oldPassword', rules: [{ type: 'isPassword' }, { type: 'match[password]' }] }
        }
      })
    })
  },

  watch: {
    'user._id' () {
      const $form = $('#form-user')
      this.$nextTick(() => {
        const { description } = this.user
        $form.form('set values', { description })
      })
    }
  }
}
</script>
