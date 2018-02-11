<template lang="jade">
Window(v-if="submission")
  .menu(slot="config")
    .ui.header links
    RouterLink.item(:to="'/user/' + submission.user._id")
      i.icon.user
      | Go to User
    RouterLink.item(:to="'/problem/' + problemId")
      i.icon.browser
      | Go to Problem
    RouterLink.item(:to="'/round/' + submission.round._id")
      i.icon.shopping.bag
      | Go to Round
    .ui.divider
    .ui.header operations
    .item(@click="rejudge")
      i.icon.save
      | Rejudge

  .ui.basic.segment(:class="{loading: isLoading}", slot="main")
    h1.ui.header.dividing Submission {{submission.index}}
    .ui.olive.labels
      //- .ui.label {{submission.permit.owner}}
      //-   .detail owner
      //- .ui.label {{submission.permit.group}}
      //-   .detail group
      .ui.label {{submission.language}}
        .detail language
      .ui.label {{submission.problem.index}}
        .detail problem
      .ui.label {{submission.round.index}}
        .detail round

    h2.ui.header.dividing code
    .ui.segment
      .ui.top.attached.label code
      pre.line-numbers
        code#code(:class="['language-' + submission.language]") {{submission.code}}

    p(v-if="submission.summary.status == 'private'") this code is private
    .ui.segment(v-if="submission.summary.status == 'CE'")
      .ui.top.attached.label Error message
      pre {{submission.summary.message}}
    h2.ui(v-if="submission.summary.status == 'running'") running
    h2.ui(v-if="submission.summary.status == 'hidden'") hidden
    div(v-if="submission.summary.status == 'finished'")
      .ui
        h1.ui.header.dividing details
        table.ui.table.segment
          thead
            tr
              th input
              th status
              th time
              th space
              th score
              th message
          tbody
            tr.positive(v-for="result in sortedResults")
              td {{result.input}}
              td {{result.status}}
              td {{result.time | decimal(3)}}
              td {{result.space | decimal(3)}}
              td {{result.score | decimal(3)}}
              td {{result.message}}
          tfoot
            tr
              th final result
              th {{submission.summary.status}}
              th {{submission.summary.time | decimal(3)}}
              th {{submission.summary.space | decimal(3)}}
              th {{submission.summary.score | decimal(3)}}
              th {{submission.summary.message}}
</template>

<script>
import { mapGetters } from 'vuex'
import { debug } from 'debug'
import Prism from 'prismjs'
import naturalSort from 'javascript-natural-sort'
import 'prismjs/components/prism-c'
import 'prismjs/components/prism-cpp'
import 'prismjs/themes/prism-solarizedlight.css'
import 'prismjs/plugins/line-numbers/prism-line-numbers'
import 'prismjs/plugins/line-numbers/prism-line-numbers.css'
import Window from '@/components/Window'
import gql from 'graphql-tag'

const log = debug('dollast:component:submission:show')

const GQL_SUBMISSION_QUERY = gql`query ($_id: ID!) {
  submission(_id: $_id) {
    _id
    index
    code
    language
    problem {
      _id
      index
      title
    }
    user {
      _id
    }
    round {
      _id
      index
      title
    }
    summary {
      time
      space
      message
      score
      status
    }
    results {
      time
      space
      message
      score
      input
      answer
      weight
    }
  }
}`

export default {
  components: {
    Window
  },

  data () {
    return {
      submission: undefined
    }
  },

  apollo: {
    submission: {
      query: GQL_SUBMISSION_QUERY,
      variables () {
        return {
          _id: this.submissionId
        }
      }
    }
  },

  computed: {
    problemId () {
      return this.submission.problem._id
    },

    submissionId () {
      return this.$route.params.submissionId
    },

    highlighted () {
      if (this.submission.code !== '') {
        return Prism.highlight(this.submission.code, Prism.languages[this.submission.language])
      } else {
        return ''
      }
    },

    sortedResults () {
      return this.submission.results.sort((a, b) => naturalSort(a.input, b.input))
    },

    ...mapGetters(['isLoading'])
  },

  methods: {
    rejudge () {
      this.$apollo.mutate({
        mutation: gql`mutation ($_id: ID) {
          rejudgeSubmission(submissionId: $_id) {
            _id
            index
          }
        }`,
        variables: {
          _id: this.submissionId
        }
      })
    }
  },

  // methods: (map-actions [\$fetch]) <<<
  //   fetch: ->>
  //     submission = await @$fetch method: \GET, url: "submission/#{@$route.params.sid}"
  //     submission.results .= sort (a, b) ->
  //       natural-sort a.input, b.input
  //     @ <<< {submission}

  watch: {
    'submission.code' () {
      this.$nextTick(() => {
        Prism.highlightAll()
      })
    }
  }

  //   $route: ->
  //     @fetch!

  // created: ->
  //   @fetch!

}
</script>
