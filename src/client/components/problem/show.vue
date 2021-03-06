<template lang="jade">
Window
  .menu(slot="config")
    .ui.header links
    RouterLink.ui.icon.labeled.item(:to="'/problem/' + problemId + '/stat'")
      i.icon.chart.bar
      | Statistics
    RouterLink.item(:to="'/round/' + roundId")
      i.icon.shopping.bag
      | Go to Round
    RouterLink.ui.icon.labeled.item(:to="{name: 'submissions', query: {problem: problemId}}")
      i.icon
      | All Submissions
    .ui.divider
    .ui.header operations
    RouterLink.ui.icon.labeled.item(:to="'/problem/' + problemId + '/update'")
      i.icon.edit
      | Update

  .ui.basic.segment(:class="{loading: isLoading}", slot="main")
    div(v-if="problem")
      h1.ui.dividing.header Problem {{problem | problem}}
      .ui.olive.labels
        .ui.label {{problem.timeLimit}} s
          .detail time limit
        .ui.label {{problem.spaceLimit}} MB
          .detail space limit
        //- .ui.label {{problem.permit.owner}}
        //-   .detail owner
        //- .ui.label {{problem.permit.group}}
        //-   .detail group
        .ui.label {{problem.round | round}}
          .detail round

      .ui.segment
        .ui.top.left.attached.label.teal description
        p(mathjax, v-html="problem.description")
      .ui.two.column.grid
        .row
          .column
            .ui.segment
              .ui.top.left.attached.label.teal input format
              p(v-html="problem.inputFormat")
          .column
            .ui.segment
              .ui.top.left.attached.label.teal output format
              p(v-html="problem.outputFormat")
        .row
          .column
            .ui.segment
              .ui.top.left.attached.label.teal sample input
              pre {{problem.sampleInput}}
          .column
            .ui.segment
              .ui.top.left.attached.label.teal sample output
              pre {{problem.sampleOutput}}

    .ui.header

    .ui.form#submit-form
      .ui.success.message
        .header Submit successful. Redirect to status in 3 seconds...
      h2.ui.dividing.header Submission
      .ui.field
        label code
        textarea(name="code", style="font-family: monospace")
      .ui.two.fields
        .ui.field
          label language
          .ui.dropdown.icon.selection#languages
            input(type="hidden", name="language")
            .default.text select your language
            i.dropdown.icon
            .menu
              .item(v-for="item in languages", :data-value="item") {{item}}

      //- permit.hello

      h2.ui.dividing.header
      .ui.field
        a.icon.labeled.ui.button.primary.floated.submit
          i.icon.rocket
          | submit
</template>

<script>
import { debug } from 'debug'
import { mapGetters } from 'vuex'
import Window from '@/components/Window'
import gql from 'graphql-tag'

const log = debug('dollast:component:problem:show')

export default {
  components: {
    Window
  },

  data () {
    return {
      languages: ['cpp', 'java', 'pas'],
      problem: null
    }
  },

  computed: {
    problemId () {
      return this.$route.params.problemId
    },

    roundId () {
      if (this.problem) {
        return this.problem.round._id
      }
      return ''
    },

    ...mapGetters(['isLoading'])
  },

  apollo: {
    problem: {
      query: gql`query Problem($_id: ID!) {
        problem(_id: $_id) {
          _id
          index
          description
          title
          inputFormat
          outputFormat
          sampleInput
          sampleOutput
          round {
            _id
            index
            title
          }
          timeLimit
          spaceLimit
          stackLimit
          outputLimit
        }
      }`,
      variables () {
        return {
          _id: this.problemId
        }
      },
      error (error) {
        const { graphQLErrors, networkError } = error
        log({ graphQLErrors, networkError })
        this.$router.push({ name: '404' })
      }
    }
  },

  watch: {
    'problem' () {
      this.$nextTick(() => {
        if (MathJax) {
          MathJax.Hub.Queue(['Typeset', MathJax.Hub])
        }
      })
    }
  },

  mounted () {
    this.$nextTick(() => {
      const $form = $('#submit-form')
      $form.form({
        onSuccess: (e, values) => {
          log('use GraphQL to submit updates')

          this.$apollo.mutate({
            mutation: gql`mutation Submit($code: String, $language: String, $problem: String) {
              submit(code: $code, language: $language, problem: $problem) {
                _id
                index
              }
            }`,
            variables: {
              problem: this.problem._id,
              ...values
            }
          })
        },
        fields: {
          code: ['minLength[4]', 'maxLength[65535]'],
          language: 'empty'
        },
        on: 'submit'
      })

      $('#languages').dropdown()
    })
  }
}
</script>
