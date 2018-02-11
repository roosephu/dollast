<template lang="jade">
  RouterLink.ui.label.hvr-underline-from-center.grey(:to="'/submission/' + sid._id") {{sid | submission}}
</template>

<script>

export default {
  props: {
    sid: Object
  }
}
</script>
