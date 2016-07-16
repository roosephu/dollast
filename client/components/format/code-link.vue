<template lang="jade">
  a.ui.label.grey(href="#/submission/{{sid}}") {{sid}}
</template>

<script lang="vue-livescript">
module.exports =
  props:
    sid: String
</script>
