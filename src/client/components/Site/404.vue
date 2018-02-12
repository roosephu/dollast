<template lang="pug">
Window
  .ui.basic.segment(slot="main")
    h1.large.text 404
</template>

<script>
import Window from '@/components/Window'

export default {
  components: {
    Window
  }
}
</script>

<style scoped>
.large.text {
  font-size: 20rem;
  text-align: center;
}
</style>
