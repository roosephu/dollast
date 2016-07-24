<template lang="jade">
div
  router-view
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
