<template lang="jade">
  .ui.grid
    error
    navbar
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
  \../actions : {load-from-token}
}

module.exports =
  vuex:
    actions: {load-from-token}
  components:
    {navbar, foot, error}
  ready: ->
    @load-from-token!

</script>
