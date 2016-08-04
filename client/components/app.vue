<template lang="jade">
div
  router-view
  error(keep-alive)
</template>

<script lang="livescript">
require! {
  \vue
  \vue-router
  \./site/error
  \../actions : {login}
}

module.exports =
  vuex:
    actions: {login}

  components:
    {error}

  ready: ->
    @login!

</script>
