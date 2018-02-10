<template lang="jade">
Window
  //- See login.vue
  form.ui.form.basic.segment(slot="main")#register-form
    h1.ui.dividing.header Register
    //- .ui.error.message
    .ui.success.message
      h3 Register successful. Login please.
    .ui.field
      label user id
      a.ui.input.icon.left
        i.icon.user
        input(name="user")
    .ui.field
      label password
      a.ui.input.icon.left
        i.icon.lock
        input(name="password", type="password")
    .ui.field
      label email
      a.ui.input.icon.left
        i.icon.mail
        input(name="email", type="email")
    a.ui.icon.labeled.button.left.primary.submit
      i.icon.sign.in
      | Register
</template>

<script>
import { debug } from 'debug'
import Window from '@/components/Window'
import gql from 'graphql-tag'

const log = debug('dollast:component:register')

const GQL_UPDATE = gql`mutation updateUser(
  $user: ID!,
  $description: String,
  $email: String,
  $password: String) {
  updateUser(
    _id: $user
    description: $description
    password: $password
    email: $email
  ) {
    _id
  }
}`

export default {
  components: {
    window
  },

  mounted () {
    this.$nextTick(() => {
      const $form = $('#register-form')
      const submit = async (e, values) => {
        e.preventDefault()
        await this.$apollo.mutate({
          mutation: GQL_UPDATE,
          variables: values
        })
      }
      $form.form({
        onSuccess: submit,
        fields: {

        }
      })
    })
  }
}
</script>
