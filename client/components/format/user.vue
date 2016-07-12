<template lang="jade">
  a.ui.label(href="#/user/{{uid}}") {{uid | user}}
</template>

<script lang="vue-livescript">
module.exports =
  props:
    uid: String
</script>
