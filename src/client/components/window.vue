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
import foot from '@/components/site/foot'
import navbar from '@/components/site/navbar'

export default {
  components: {
    foot,
    navbar
  }
}
</script>
