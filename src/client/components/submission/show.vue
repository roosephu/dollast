<template lang="jade">
window
  .menu(slot="config")
    .ui.header links
    a.item(:href="'#!/user/' + submission.user")
      i.icon.user
      | Go to User
    a.item(:href="'#!/problem/' + submission.problem._id")
      i.icon.browser
      | Go to Problem
    a.item(:href="'#!/round/' + submission.round")
      i.icon.shopping.bag
      | Go to Round

  .ui.basic.segment(:class="{loading: isLoading}", slot="main")
    h1.ui.header.dividing Submission {{$route.params.sid}}
    .ui.olive.labels
      .ui.label {{submission.permit.owner}}
        .detail owner
      .ui.label {{submission.permit.group}}
        .detail group
      .ui.label {{submission.language}}
        .detail language
      .ui.label {{submission.problem._id}}
        .detail problem

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
            tr.positive(v-for="result in submission.results")
              td {{result.input}}
              td {{result.status}}
              td {{result.time | decimal 3}}
              td {{result.space | decimal 3}}
              td {{result.score | decimal 3}}
              td {{result.message}}
          tfoot
            tr
              th final result
              th {{submission.summary.status}}
              th {{submission.summary.time | decimal 3}}
              th {{submission.summary.space | decimal 3}}
              th {{submission.summary.score | decimal 3}}
              th {{submission.summary.message}}
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import { debug } from 'debug'
import Prism from 'prismjs'
import naturalSort from 'javascript-natural-sort'
import 'prismjs/components/prism-c'
import 'prismjs/components/prism-cpp'
import 'prismjs/themes/prism-solarizedlight.css'
import 'prismjs/plugins/line-numbers/prism-line-numbers'
import 'prismjs/plugins/line-numbers/prism-line-numbers.css'
import window from '@/components/window'

const log = debug('dollast:component:submission:show')

export default {
  components: {
    window
  },

  data () {
    return {
      submission: null
    }
  },

  // data: ->
  //   submission:
  //     code: ""
  //     summary: {}
  //     results: []
  //     problem:
  //       _id: "0"
  //     permit:
  //       owner: ""
  //       group: ""

  computed: {
    problem () {
      return this.submission.problem._id
    },

    highlighted () {
      if (this.submission.code !== '') {
        return Prism.highlight(this.submission.code, Prism.languages[this.submission.language])
      } else {
        return ''
      }
    },

    ...mapGetters(['isLoading'])
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
