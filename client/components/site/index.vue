<template lang="jade">
view
  div(slot="main")
    h1.ui.dividing.header welcome
    h3.ui This is dollast, an buggy online judge.
    h3.ui Hint: Try put your mouse over the logo in different pages.
</template>

<script lang="livescript">
require! {
  \../view
}

module.exports = 
  components:
    {view}
</script>
