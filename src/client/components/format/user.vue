<template lang="jade">
  a.ui.label.hvr-underline-from-center(:href="'#/user/' + user") {{user | user}}
</template>

<script>
export default {
  props: {
    user: String
  }
}
</script>
