<<template lang="pug">
div
</template>

<script>
import gql from 'graphql-tag'

export default {
  apollo: {
    defaultRoundId: {
      query: gql`{
        defaultRoundId
      }`,
      update ({defaultRoundId}) {
        this.$router.push({
          name: 'round',
          params: { roundId: defaultRoundId }
        })
      }
    }
  }
}

</script>
