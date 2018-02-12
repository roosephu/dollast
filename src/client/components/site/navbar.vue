<template lang="jade">
  .ui.left.fixed.menu.vertical.borderless.inverted.blue.labeled
    .item
    .ui.labeled.icon.item.dropdown#configuration
      img.centered.tiny.ui.image(src="/atm-inverted.png", align="middle")
      slot
    .ui.divider
    RouterLink.item(to="/")
      i.icon.home
      | Home
    RouterLink.item(to="/problems")
      i.icon.browser
      | Problems
    RouterLink.item(to="/submissions")
      i.icon.info.circle
      | Submissions
    RouterLink.item(to="/rounds")
      i.icon.shopping.bag
      | Rounds
    RouterLink.item(to="/about")
      i.icon.help.circle
      | About
    .ui.divider
    RouterLink.item(v-if="user != undefined", :to="'/user/' + user")
      i.icon.user
      | {{user}}
    RouterLink.item(v-else, to="/user/login")
      i.icon.sign.in
      | Sign in
    a.item(v-if="user != undefined", @click="logout")
      i.icon.sign.out
      | Logout
    RouterLink.item(v-else, to="/user/register")
      i.icon.signup
      | Register
</template>

<script>
import { debug } from 'debug'
import { mapGetters, mapActions, mapMutations } from 'vuex'

const log = debug('dollast:navbar')

export default {
  computed: {
    ...mapGetters(['user'])
  },

  methods: {
    ...mapActions(['login']),
    ...mapMutations(['logout'])
  },

  mounted () {
    $('#configuration').dropdown({
      on: 'hover'
    })
  }
}
</script>
