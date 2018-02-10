<<template lang="pug">
</template>

<script>
import gql from 'graphql-tag'

export default {
  apollo: {
    defaultRoundId: {
      query: gql`query {
        defaultRoundId
      }`,
      update ({ defaultRoundId }) {
        this.$router.push({
          name: 'round',
          params: { roundId: defaultRoundId }
        })
      }
    }
  }
}
</script>
