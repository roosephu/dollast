<template lang="jade">
view
  div(slot="main")
    h1.ui.dividing.header welcome
    h3.ui this is dollast, an buggy online judge.
</template>

<script lang="vue-livescript">
require! {
  \../view
}

module.exports = 
  components:
    {view}
</script>
