<template lang="jade">
window
  //- Don't add (:class="{loading: isLoading}") since it doesn't work with Vue.js
  //- The status cannot be updated by both SemanticIO and Vue.
  form.ui.form.basic.segment(slot="main")#login-form
    h1.ui.dividing.header Login
    .ui.success.message
      .header Login successfully. Redirect to problem list in 3 seconds.
    .ui.field
      label user id
      .ui.icon.input.left
        i.icon.user
        input(name="user")
    .ui.field
      label password
      .ui.icon.input.left
        i.icon.lock
        input(name="password", type="password")
    .ui.icon.labeled.button.left.primary.submit
      i.icon.sign.in
      | Login
</template>

<script>
import { debug } from 'debug'
import window from '@/components/window'
import gql from 'graphql-tag'
import { mapMutations } from 'vuex'

const log = debug('dollast:component:login')

export default {
  components: {
    window
  },

  methods: {
    ...mapMutations(['login'])
  },

  mounted () {
    const this$ = this
    this.$nextTick(() => {
      const $form = $('#login-form')
      const submit = (e, values) => {
        e.preventDefault()
        this.$apollo.mutate({
          mutation: gql`mutation login($user: String!, $password: String!) {
            login(_id: $user, password: $password)
          }`,
          variables: values,
          update (store, { data }) {
            this$.login()
          }
        })
      }

      $form.form({ onSuccess: submit })
    })
  }
}
</script>
