<template lang="jade">
  .ui.left.fixed.menu.vertical.borderless.inverted.blue.labeled
    .item
    .ui.labeled.icon.item.dropdown#configuration
      img.centered.tiny.ui.image(src="/atm-inverted.png", align="middle")
      slot
    .ui.divider
    a.item(href="#/")
      i.icon.home
      | Home
    a.item(href="#/problem")
      i.icon.browser
      | Problems
    a.item(href="#/submission")
      i.icon.info.circle
      | Submissions
    a.item(href="#/round")
      i.icon.shopping.bag
      | Rounds
    a.item(href="#/about")
      i.icon.help.circle
      | About
    .ui.divider
    a.item(v-if="user != undefined", :href="'#/user/' + user")
      i.icon.user
      | {{user}}
    a.item(v-else, href="#/user/login")
      i.icon.sign.in
      | Sign in
    a.item(v-if="user != undefined", @click="logout")
      i.icon.sign.out
      | Logout
    a.item(v-else, href="#/user/register")
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
