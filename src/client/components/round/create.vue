<template lang="pug">
</template>

<script>
import gql from 'graphql-tag'

export default {
  apollo: {
    roundId: {
      query: gql`{
        roundId: getObjectID
      }`,
      update ({ roundId }) {
        this.$router.push({ path: `round/${roundId}/update` })
      }
    }
  }
}
</script>
