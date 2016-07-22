<template lang="jade">
  .ui.left.sidebar.vertical.menu.inverted.visible.icon.labeled.borderless.blue
    a.item.labeled.header(href="#/")
      img(src="/atm-inverted.png", width="60", height="60")
    a.item.labeled(href="#/problem")
      i.icon.browser
      | Problem
    a.item.labeled(href="#/submission")
      i.icon.info.circle
      | Submissions
    a.item.labeled(href="#/pack")
      i.icon.users
      | Packs
    a.item.labeled(href="#/about")
      i.icon.help.circle
      | About
    a.item.labeled(v-if="user != undefined", href="#/user/{{user}}")
      i.icon.user
      | {{user}}
    a.item.labeled(v-else, href="#/user/login")
      i.icon.sign.in
      | Sign in
    a.item.labeled(v-if="user != undefined", @click="logout")
      i.icon.sign.out
      | Logout
    a.item.labeled(v-else, href="#/user/register")
      i.icon.signup
      | Register
</template>

<script lang="vue-livescript">
require! {
  \debug
  \../../actions : {logout}
}
log = debug \dollast:navbar

module.exports =
  vuex:
    getters:
      user: (.session.user)
    actions:
      {logout}

  methods:
    logout: ->
      @logout!

</script>
