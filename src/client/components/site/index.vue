<template lang="jade">
Window
  .menu(slot="config")
    .ui.header links
    .item
      i.icon.home
      | Nothing here

  div(slot="main")
    h1.ui.dividing.header welcome
    h3.ui This is dollast, a buggy online judge.
    h3.ui Hint: Try put your mouse over the logo in different pages.
</template>

<script>
import Window from '@/components/Window'

export default {
  components: {
    Window
  }
}
</script>
