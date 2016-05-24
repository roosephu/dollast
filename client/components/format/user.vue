<template lang="jade">
  a.ui.label(href="#/user/{{uid}}") {{uid}}
</template>

<script lang="vue-livescript">
module.exports =
  props:
    uid: String
</script>
