<template lang="jade">
  a.ui.label.grey(href="#/solution/{{sid}}") {{sid}}
</template>

<script lang="vue-livescript">
module.exports =
  props:
    sid: Number
</script>
