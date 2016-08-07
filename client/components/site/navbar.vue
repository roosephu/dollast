<template lang="jade">
  .ui.left.fixed.menu.vertical.borderless.inverted.blue.labeled
    .item
    .ui.labeled.icon.item.dropdown#configuration
      img.centered.tiny.ui.image(src="/atm-inverted.png", align="middle")
      slot(name="config")
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
    a.item(href="#/pack")
      i.icon.shopping.bag
      | Packs
    a.item(href="#/about")
      i.icon.help.circle
      | About
    .ui.divider
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

<script>
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
