<template lang="jade">
window(v-if="problem")
  .menu(slot="config")
    .ui.header links
    a.item(:href="'#!/problem/' + problem._id")
      i.icon.browser
      | Go to Problem
    router-link.item(to="{name: 'submissions', query: {problem: problem._id}}")
      i.icon
      | All submissions

  .ui.basic.segment(:class="{loading: isLoading}", slot="main")
    h1.ui.header.dividing Statistics for Problem {{problem._id}}
    // problem(:prob="problem")

    h3.ui.header.dividing numbers
    .ui.statistics
      .statistic(v-for="(val, key) in statistics")
        .value {{val}}
        .label {{key}}
</template>

<script>
import { mapGetters } from 'vuex'
// import { debug } from 'debug'
import Window from '@/components/Window'
import ProblemLink from '@/components/format/ProblemLink'
import gql from 'graphql-tag'
import * as _ from 'lodash'

// const log = debug('dollast:component:problem:stat')

function generateStat (sols) {
  if (!sols || sols.length === 0) {
    return {
      solved: 0,
      mean: 0,
      median: 0,
      stddev: 0
    }
  }

  const scores = sols.map(sol => sol.submission.summary.score || 0)
  const mean = _.mean(scores)
  const median = scores[Math.floor(scores.length / 2)]
  const variance = _.mean(scores.map(val => val * val)) - mean * mean
  const stddev = Math.sqrt(variance)
  const solved = scores.filter(x => x === 1).length

  return {solved, mean, median, stddev}
}

export default {
  data () {
    return {
      problem: null
    }
  },

  computed: {
    statistics () {
      return generateStat(this.problem.statistics)
    },

    ...mapGetters(['isLoading'])
  },

  apollo: {
    problem: {
      query: gql`query ($_id: ID!) {
        problem(_id: $_id) {
          _id
          index
          title
          statistics {
            _id
            numSubmissions
            submission {
              _id
              index
              summary {
                score
              }
            }
          }
        }
      }`,
      variables () {
        return {
          _id: this.$route.params.problemId
        }
      }
    }
  },

  components: {
    Window,
    ProblemLink
  }
}
</script>
