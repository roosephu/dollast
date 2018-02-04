<template lang="jade">
window
  .menu(slot="config")
    .ui.header Links
    a.item(:href="'#/problem/' + problemId")
      i.icon.reply
      | Go to Problem
    .ui.divider
    .ui.header Operations
    .item(v-if="problemId != ''", @click="remove")
      i.icon.cancel
      | Delete
    a.item(v-if="problemId != ''", :href="'#/problem/' + problemId + '/data'")
      i.icon.archive
      | Dataset Manage

  .ui.form.basic.segment(:class="{loading: isLoading}", slot="main")#problem-modify
    h2.ui.dividing.header {{title}}
    .ui.error.message

    h3.ui.dividing.header Configuration
    .ui.three.fields
      .ui.field.twelve.wide
        label title
        .ui.input
          input(name="title")
      .ui.field.four.wide
        label round id
        //- round-selector#round(:round="round")
        .ui.input
          input(name="round")
    .ui.field
      label judger
      .ui.dropdown.icon.fluid.selection#judger
        input(type="hidden", name="judger")
        .default.text choose a judger
        i.dropdown.icon
        .menu
          .item(v-for="(value, key) of judgers", :data-value="key") ({{key}}) {{value}}

    .ui.four.fields
      .ui.field
        label time limit (s)
        .ui.input
          input(name="timeLimit", type="number")
      .ui.field
        label space limit (MB)
        .ui.input
          input(name="spaceLimit", type="number")
      .ui.field
        label stack limit (MB)
        .ui.input
          input(name="stackLimit", type="number")
      .ui.field
        label output limit (MB)
        .ui.input
          input(name="outputLimit", type="number")

    h3.ui.dividing.header Description
    .ui.field
      .ui.field
        label description
        ckeditor#description(name="description")
    .ui.two.fields
      .ui.field
        label input format
        ckeditor#inputFormat(name="inputFormat")
      .ui.field
        label output format
        ckeditor#outputFormat(name="outputFormat")
    .ui.two.fields
      .ui.field
        label sample input
        textarea(name="sampleInput")
      .ui.field
        label sample output
        textarea(name="sampleOutput")

    //- permit

    .ui.field
      .ui.icon.labeled.button.primary.submit
        i.icon.save
        | Save
</template>

<script>
import { debug } from 'debug'
import { mapGetters } from 'vuex'
import ckeditor from 'vue-ckeditor2'
import window from '@/components/window'
import roundSelector from '@/components/elements/round-selector'
import judgers from '@/../common/judgers'
import gql from 'graphql-tag'

const log = debug('dollast:component:problem:modify')

function flattenObject (obj) {
  let ret = {}
  for (const [key, val] of obj) {
    if (typeof val === 'object') {
      Object.assign(ret, flattenObject(val))
    } else {
      ret[key] = val
    }
  }
  return ret
}

function setFormValues (data) {
  log('update values', data)
  let problem = Object.assign({}, data)
  if (data.round._id) {
    problem.round = data.round._id
  }
  const $form = $('#problem-modify')
  $form.form('set values', problem)
}

const QUERY_GQL = gql`query Problem($problemId: String) {
  problem(_id: $problemId) {
    _id
    description
    title
    inputFormat
    outputFormat
    sampleInput
    sampleOutput
    round {
      _id
      title
    }
    timeLimit
    spaceLimit
    stackLimit
    outputLimit
    judger
  }
}`

const UPDATE_GQL = gql`mutation Update (
  $_id: String!,
  $description: String,
  $title: String,
  $inputFormat: String,
  $outputFormat: String,
  $sampleInput: String,
  $sampleOutput: String,
  $round: String,
  $timeLimit: Float
  $spaceLimit: Float,
  $stackLimit: Float,
  $outputLimit: Float,
  $judger: String) {
  updateProblem(
    _id: $_id,
    description: $description,
    title: $title,
    inputFormat: $inputFormat,
    outputFormat: $outputFormat,
    sampleInput: $sampleInput,
    sampleOutput: $sampleOutput,
    round: $round,
    timeLimit: $timeLimit,
    spaceLimit: $spaceLimit,
    stackLimit: $stackLimit,
    outputLimit: $outputLimit,
    judger: $judger) {
    _id
  }
}`

export default {
  components: {
    window,
    roundSelector,
    ckeditor
  },

  data () {
    return {
      round: null,
      judgers,
      problem: null
    }
  },

  apollo: {
    problem: {
      query: QUERY_GQL,
      variables () {
        return {
          problemId: this.problemId
        }
      }
    }
  },

  computed: {
    problemId () {
      return this.$route.params.problemId
    },

    title () {
      if (this.problem && this.problem._id !== '') {
        return `Problem ${this.problem._id}. ${this.problem.title}`
      } else {
        return 'Create New Problem'
      }
    },

    ...mapGetters(['isLoading'])
  },

  methods: {
    remove () {

    }
  },

  mounted () {
    this.$nextTick(() => {
      $('#judger').dropdown()

      const $form = $('#problem-modify')

      $form.form({
        onSuccess: async (e, values) => {
          e.preventDefault()

          values._id = this.problemId
          values.timeLimit = parseFloat(values.timeLimit)
          values.spaceLimit = parseFloat(values.spaceLimit)
          values.outputLimit = parseFloat(values.outputLimit)
          values.stackLimit = parseFloat(values.stackLimit)
          values.description = CKEDITOR.instances.description.getData()
          values.inputFormat = CKEDITOR.instances.inputFormat.getData()
          values.outputFormat = CKEDITOR.instances.outputFormat.getData()

          await this.$apollo.mutate({
            mutation: UPDATE_GQL,
            variables: values
          })
        },
        fields: {
          title: ['minLength[2]', 'maxLength[63]'],
          judger: 'empty',
          timeLimit: 'positive',
          spaceLimit: 'positive',
          stackLimit: 'positive',
          outputLimit: 'positive',
          description: 'maxLength[65535]',
          inputFormat: 'maxLength[65535]',
          outputFormat: 'maxLength[65535]',
          sampleInput: 'maxLength[65535]',
          sampleOutput: 'maxLength[65535]'
        }
      })
    })
  },

  watch: {
    'problem' () {
      this.$nextTick(() => {
        setFormValues(this.problem)
      })
    }
  }
}
</script>
