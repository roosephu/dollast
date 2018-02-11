<template lang="jade">
  RouterLink.ui.label.hvr-underline-from-center(:to="'/user/' + user._id") {{user | user}}
</template>

<script>
export default {
  props: {
    user: Object
  }
}
</script>
