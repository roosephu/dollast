<template lang="jade">
  RouterLink.ui.label.green.hvr-underline-from-center(v-if="prob && prob._id", :to="'/problem/' + prob._id") {{prob | problem}}
  a.ui.label.green.hvr-underline-from-center(v-else) hidden
</template>

<script>

export default {
  props: {
    prob: Object
  }
}
</script>
