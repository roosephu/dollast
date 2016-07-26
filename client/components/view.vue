<template lang="jade">
div
  navbar
    slot(slot="config", name="config")
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

<script lang="vue-livescript">
require! {
  \vue
  \./site/foot
  \./site/navbar
  \./site/error
}

module.exports = 
  components:
    {foot, navbar, error}

</script>