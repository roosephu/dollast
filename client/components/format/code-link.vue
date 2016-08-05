<template lang="jade">
  a.ui.label.hvr-underline-from-center.grey(href="#/submission/{{sid}}") {{sid}}
</template>

<script lang="livescript">
module.exports =
  props:
    sid: String
</script>
