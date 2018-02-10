<template lang="jade">
  a.ui.label.hvr-underline-from-center(:href="'#/user/' + user._id") {{user | user}}
</template>

<script>
export default {
  props: {
    user: Object
  }
}
</script>
