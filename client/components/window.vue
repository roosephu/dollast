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

<script lang="livescript">
require! {
  \./site/foot
  \./site/navbar
  \./site/error
}

module.exports =
  components:
    {foot, navbar, error}

</script>
