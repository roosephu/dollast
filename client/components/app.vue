<template lang="jade">
  .ui.grid
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
  \./site/foot
  \./site/navbar
  \vue-router
  \vue
  \../actions : {load-from-token}
}

module.exports =
  vuex:
    actions: {load-from-token}
  components:
    {navbar, foot}
  ready: ->
    @load-from-token!

</script>
