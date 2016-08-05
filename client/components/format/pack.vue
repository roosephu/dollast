<template lang="jade">
  a.ui.label.hvr-underline-from-center.light.teal(v-if="pack", href="#/pack/{{pack._id}}") {{pack | pack}}
  a.ui.label.hvr-underline-from-center.light.teal(v-else) hidden
</template>

<script lang="livescript">
module.exports =
  props:
    pack: Object
</script>
