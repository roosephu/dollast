<template lang="jade">
  a.ui.label.hvr-underline-from-center.grey(:href="'#/submission/' + sid._id") {{sid | submission}}
</template>

<script>

export default {
  props: {
    sid: Object
  }
}
</script>
