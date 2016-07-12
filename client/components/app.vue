<template lang="jade">
  navbar
  .ui.grid
    error
    .row
    .row
      .three.wide.column
      .ten.wide.column
        router-view
    .row
      .twelve.wide.column.centered
        foot
</template>

<script lang="vue-livescript">
require! {
  \vue
  \vue-router
  \./site/foot
  \./site/navbar
  \./site/error
  \../actions : {login}
}

module.exports =
  vuex:
    actions: {login}

  components:
    {navbar, foot, error}

  ready: ->
    @login!

</script>
