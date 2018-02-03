<template lang="jade">
  a.ui.label.hvr-underline-from-center.grey(:href="'#/submission/' + sid") {{sid}}
</template>

<script>

export default {
  props: {
    sid: String
  }
}
</script>
