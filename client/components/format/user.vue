<template lang="jade">
  a.ui.label(href="#/user/{{user}}") {{user | user}}
</template>

<script lang="livescript">
module.exports =
  props:
    user: String
</script>
