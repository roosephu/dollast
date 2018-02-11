<template lang="jade">
  RouterLink.ui.label.hvr-underline-from-center.light.teal(v-if="round", :to="'/round/' + round._id") {{round | round}}
  a.ui.label.hvr-underline-from-center.light.teal(v-else) hidden
</template>

<script>
export default {
  props: {
    round: Object
  }
}
</script>
