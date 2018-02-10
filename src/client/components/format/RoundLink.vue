<template lang="jade">
  a.ui.label.hvr-underline-from-center.light.teal(v-if="round", :href="'#/round/' + round._id") {{round | round}}
  a.ui.label.hvr-underline-from-center.light.teal(v-else) hidden
</template>

<script>
export default {
  props: {
    round: Object
  }
}

</script>
