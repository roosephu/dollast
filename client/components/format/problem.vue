<template lang="jade">
  a.ui.label.green(v-if="prob && prob._id > 0", href="#/problem/{{prob._id}}") {{prob._id}}. {{prob.outlook.title}}
  a.ui.label.green(v-else) hidden
</template>

<script lang="vue-livescript">
module.exports =
  props:
    prob: Object
</script>
