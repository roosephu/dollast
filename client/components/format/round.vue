<template lang="jade">
  a.ui.label.light.teal(v-if="rnd && rnd._id > 0", href="#/round/{{rnd._id}}") {{rnd._id}}. {{rnd.title}}
  a.ui.label.light.teal(v-else) hidden
</template>

<script lang="vue-livescript">
module.exports =
  props:
    rnd: Object
</script>
