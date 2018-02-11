<template lang="jade">
div
  navbar
    slot(name="config")
  .ui.grid
    .row
      .four.wide.column
      .ten.wide.column#viewpoint
        slot(name="main")
    .row
      .two.wide.column
      .twelve.wide.column.centered
        foot
</template>

<script>
import Foot from '@/components/site/Foot'
import Navbar from '@/components/site/Navbar'

export default {
  components: {
    Foot,
    Navbar
  }
}
</script>
