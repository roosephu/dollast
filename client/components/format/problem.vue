<template lang="jade">
  a.ui.label.green.hvr-underline-from-center(v-if="prob && prob._id > 0", href="#/problem/{{prob._id}}") {{prob | problem}}
  a.ui.label.green.hvr-underline-from-center(v-else) hidden
</template>

<script lang="livescript">
module.exports =
  props:
    prob: Object
</script>
