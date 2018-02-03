<<template lang="pug">
div
</template>

<script>
import gql from 'graphql-tag'

export default {
  apollo: {
    problemId: {
      query: gql`{
        problemId: getObjectID
      }`,
      update ({problemId}) {
        this.$router.push({
          name: 'problem',
          params: { problemId }
        })
      }
    }
  }
}
</script>
