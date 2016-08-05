<template lang="jade">
  a.ui.label.hvr-underline-from-center(href="#/user/{{user}}") {{user | user}}
</template>

<script lang="livescript">
module.exports =
  props:
    user: String
</script>
