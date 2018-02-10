<template lang="jade">
Window
  .form.menu(slot="config")
    .ui.header Pagination
    a.icon.labeled.item(:class="{'disabled': query.page == 1}", @click="go(1)")
      i.icon.angle.double.left
      | Top
    a.icon.labeled.item(:class="{'disabled': query.page == 1}", @click="go(query.page - 1)")
      i.icon.angle.left
      | Previous page
    .icon.labeled.item
      i.icon.thin.circle
      | Current: {{query.page}}
    a.icon.labeled.item(@click="go(query.page + 1)")
      i.icon.angle.right
      | Next page
    //- .ui.divider
    //- .ui.header Options
    //- .ui.left.icon.input
    //-   i.icon.user
    //-   input(name="user", placeholder="user")
    //- .ui.left.icon.input
    //-   i.icon.browser
    //-   input(name="problem", placeholder="problem")
    //- .ui.left.icon.input
    //-   i.icon.shopping.bag
    //-   input(name="round", placeholder="round")
    //- //- .ui.left.icon.input
    //- //-   i.icon.calendar
    //- //-   input(name="after", placeholder="submitted after")
    //- //- .ui.left.icon.input
    //- //-   i.icon.calendar
    //- //-   input(name="before", placeholder="submitted before")
    //- .ui.input.labeled
    //-   .ui.dropdown.compact.button.label#relationship
    //-     input(type="hidden", name="relationship")
    //-     .default.text ?
    //-     .menu
    //-       .item(data-value="lt") $\leqslant$
    //-       .item(data-value="gt") $\geqslant$
    //-   input(name="threshold", placeholder="threshold")
    //- .ui.dropdown.selection.item#langauge
    //-   i.dropdown.icon
    //-   input(type="hidden", name="language")
    //-   span Language:
    //-   span.text
    //-   .menu
    //-     .item(v-for="item in languages", :data-value="item") {{item}}
    //-     .item(data-value="all") all
    //- .ui.divider
    //- .ui.header Form Operations
    //- .ui.item.icon.submit
    //-   i.icon.save
    //-   | Submit
    //- .ui.item.icon(@click="clear")
    //-   i.icon.save
    //-   | Clear

  .ui.basic.segment(:class="{loading: isLoading}", slot="main")
    h1.ui.dividing.header Submissions

    .ui.form.segment.basic#submission
      //- h3.ui.dividing.header Filters
      .ui.fields.inline
        .ui.field
          label user
          .ui.left.input
            //- i.icon.user
            input(name="user")
        .ui.field
          label problem
          .ui.left.input
            //- i.icon.browser
            input(name="problem")
        .ui.field
          label round
          .ui.left.input
            //- i.icon.shopping.bag
            input(name="round")
        .ui.field
          label threshold
          .ui.input.labeled
            .ui.dropdown.compact.button.label#relationship
              input(type="hidden", name="relationship")
              .default.text ?
              .menu
                .item(data-value="lt") $\leqslant$
                .item(data-value="gt") $\geqslant$
            input(name="threshold")
        .ui.field
          label language
          .ui.dropdown.selection.item#langauge
            i.dropdown.icon
            input(type="hidden", name="language")
            span Language:
            span.text
            .menu
              .item(v-for="item in languages", :data-value="item") {{item}}
              .item(data-value="all") all
        .ui.field
          //- label submit
          a.icon.ui.labeled.button.primary.submit
            i.icon.save
            | Submit
        .ui.field
          //- label clear
          a.icon.ui.labeled.button(@click="clear")
            i.icon.save
            | Clear

    table.ui.table.large.green.selectable.center.aligned.single.line
      thead
        tr
          th.collapsing.right id
          th.collapsing time
          th problem
          th user
          th score
          th time
          th space
          th.collapsing lang
          th.collapsing round
      tbody
        tr(v-for="sol in submissions", :class="getRowColor(sol)")
          td
            SubmissionLink(:sid="sol._id")
          td
            .ui.label.mini {{sol.date | conciseTime}}
          td
            ProblemLink(:prob="sol.problem")
          td
            UserLink(:user="sol.user")
          td(v-if="sol.summary.status == 'finished'") {{sol.summary.score | decimal(3)}}
          td(v-else) {{sol.summary.status}}
          td(v-if="sol.summary.status == 'finished'") {{sol.summary.time | decimal(3)}}
          td(v-else)
          td(v-if="sol.summary.status == 'finished'") {{sol.summary.space | decimal(3)}}
          td(v-else)
          td {{sol.language}}
          td(v-if="sol.round")
            RoundLink(:round="sol.round")
          td(v-else)
    // .ui.icon.labeled.button.floated.right.primary
    //   i.icon.refresh
    //   | refresh
</template>

<script>
import { mapGetters } from 'vuex'
import { debug } from 'debug'
import Window from '@/components/Window'
import Moment from 'moment'
import ProblemLink from '@/components/format/ProblemLink'
import UserLink from '@/components/format/UserLink'
import RoundLink from '@/components/format/RoundLink'
import SubmissionLink from '@/components/format/SubmissionLink'
import gql from 'graphql-tag'
import * as _ from 'lodash'

const log = debug('dollast:component:submission:list')

const GQL_QUERY = gql`query ($user: String, $problem: String, $round: String, $maxScore: Float, $minScore: Float, $language: String, $page: Int) {
  submissions(user: $user, problem: $problem, round: $round, maxScore: $maxScore, minScore: $minScore, language: $language, page: $page) {
    _id
    language
    problem {
      _id
      title
    }
    user {
      _id
    }
    round {
      _id
      title
    }
    summary {
      time
      space
      score
      status
    }
  }
}`

function getFormValues () {
  const $form = $('#submission')
  let ret = $form.form('get values')
  ret = _.pickBy(ret, x => x !== '')
  if (ret.threshold) ret.threshold = parseFloat(ret.threshold)
  // if (ret.before) ret.before = new Moment(ret.before).valueOf()
  // if (ret.after) ret.after = new Moment(ret.after).valueOf()

  return ret
}

function setFormValues (values) {
  values = Object.assign({}, values)
  if (values.before) values.before = new Moment(values.before).format('YYYY-MM-DD HH:mm:ss')
  if (values.after) values.after = new Moment(values.after).format('YYYY-MM-DD HH:mm:ss')
  // log('setting form values', values)
  $('#submission').form('set values', values)
}

export default {
  data () {
    return {
      submissions: [],
      languages: ['cpp', 'java', 'pas'],
      query: {
        page: 1
      }
    }
  },

  computed: {
    ...mapGetters(['isLoading'])
  },

  components: {
    Window,
    ProblemLink,
    UserLink,
    RoundLink,
    SubmissionLink
  },

  methods: {
    go (page) {
      this.query.page = page
      this.$router.push({
        name: 'submissions',
        query: this.query
      })
    },

    clear () {
      $('#submission').form('clear')
    },

    getRowColor (submission) {
      const { summary } = submission
      if (summary.status === 'running') {
        return []
      } else if (summary.score > 0.999) {
        return ['positive']
      } else if (summary.score < 0.001) {
        return ['negative']
      }
      return []
    }

    // fetch: ->>
    //   {query} = @$route
    //   if query.page
    //     query.page |>= parse-int
    //   else
    //     query.page = 1
    //   if query.threshold
    //     query.threshold |>= parse-float
    //   if query.before
    //     query.before |>= parse-int
    //   if query.after
    //     query.after |>= parse-int

    //   @$next-tick ->
    //     set-form-values query

    //   @submissions = await @$fetch method: \GET, url: \submission, params: query
    //   @query = query
  },

  apollo: {
    submissions: {
      query: GQL_QUERY,
      variables () {
        const { query } = this.$route
        this.$nextTick(() => setFormValues(query))

        const values = {}
        Object.assign(values, _.pickBy(_.pick(query, ['user', 'problem', 'round', 'langugage'])))

        if (values.relationship === 'lt') values.maxScore = parseFloat(values.threshold)
        if (values.relationship === 'ge') values.minScore = parseFloat(values.threshold)
        if (query.page) values.page = parseInt(query.page)

        return values
      }
    }
  },

  mounted () {
    this.$nextTick(() => {
      setFormValues(getFormValues())
      const submit = (e, values) => {
        values = getFormValues()
        log({ values, this: this })
        this.$router.push({
          name: 'submissions',
          query: values
        })
      }

      const $form = $('#submission')
      // $form.form('add fields', SHORTHAND_FIELDS)
      $form.form({
        inline: true,
        onSuccess: submit,
        onFailure: (errors, fields) => log(errors, fields),
        fields: {
          user: { optional: true, rules: [{ type: 'isUserId' }] },
          threshold: { optional: true, rules: [{ type: 'number[0..1]' }] },
          relationship: { depends: 'threshold', rules: [{ type: 'empty' }] },
          problem: { optional: true, rules: [{ type: 'isObjectId' }] },
          round: { optional: true, rules: [{ type: 'isObjectId' }] },
          language: { optional: true }
        }
      })

      $('#relationship, #language, #search').dropdown({ on: 'hover' })
      if (MathJax) MathJax.Hub.Queue(['Typeset', MathJax.Hub])
    })
  }
}
</script>
