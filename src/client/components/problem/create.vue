<<template lang="pug">
</template>

<script>
import gql from 'graphql-tag'

export default {
  apollo: {
    problemId: {
      query: gql`{
        problemId: getObjectID
      }`,
      update ({ problemId }) {
        this.$router.push(`/problem/${problemId}/update`)
      }
    }
  }
}
</script>
