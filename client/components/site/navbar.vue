<template lang="jade">
  .ui.left.fixed.menu.vertical.borderless.blue.inverted.labeled.pointing
    a.item.labeled.header(href="#/")
      img.centered.tiny.ui.image(src="/atm-inverted.png", align="middle")
    a.item(href="#/problem")
      i.icon.browser
      | Problems
    a.item(href="#/submission")
      i.icon.info.circle
      | Submissions
    a.item(href="#/pack")
      i.icon.shopping.bag
      | Packs
    a.item(href="#/about")
      i.icon.help.circle
      | About
    .ui.icon.labeled.dropdown.item#configuration
      i.icon.configure
      | Functions
      slot(name="config")
    .item.divider
    a.item(v-if="user != undefined", href="#/user/{{user}}")
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
  
  ready: ->
    $ \#configuration .dropdown do
      on: \hover

</script>
