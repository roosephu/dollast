<template lang="jade">
  // 
    .row
    .ui.blue.inverted.page.grid.borderless.menu.navbar
      .header.item dollast
      a.item.labeled(href="#/")
        i.icon.home
        | Home
      a.item.labeled(href="#/problem")
        i.icon.browser
        | Problem
      a.item.labeled(href="#/submission")
        i.icon.info.circle
        | Status
      a.item.labeled(href="#/round")
        i.icon.users
        | Contest
      .right.menu
        .item
          .ui.input.icon.inverted.small
            i.icon.search.link
            input(placeholder="ID or Search")
        a.item.labeled(v-if="uid != undefined", href="#/user/{{uid}}")
          i.icon.user
          | {{uid}}
        a.item.labeled(v-else, href="#/user/login")
          i.icon.sign.in
          | Sign in
        a.item.labeled(v-if="uid != undefined", @click="logout")
          i.icon.sign.out
          | Logout
        a.item.labeled(v-else, href="#/user/register")
          i.icon.signup
          | Register
  .ui.left.sidebar.vertical.menu.inverted.visible.icon.labeled.borderless.blue
    // .header.item dollast
    a.item.labeled.header(href="#/")
      // i.icon.home
      img(src="/atm-inverted.png", width="60", height="60")
      // | dollast
    a.item.labeled(href="#/problem")
      i.icon.browser
      | Problem
    a.item.labeled(href="#/submission")
      i.icon.info.circle
      | Submissions
    a.item.labeled(href="#/round")
      i.icon.users
      | Contest
    a.item.labeled(href="#/about")
      i.icon.help.circle
      | About
    // .right.menu
    a.item.labeled(v-if="uid != undefined", href="#/user/{{uid}}")
      i.icon.user
      | {{uid}}
    a.item.labeled(v-else, href="#/user/login")
      i.icon.sign.in
      | Sign in
    a.item.labeled(v-if="uid != undefined", @click="logout")
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
      uid: (.session.uid)
    actions:
      {logout}

  methods:
    logout: ->
      @logout!

</script>
