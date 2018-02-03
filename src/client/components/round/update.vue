<template lang="jade">
window
  .menu(slot="config")
    .ui.header links
    a.item(:href="'#/round/' + round._id")
      i.icon.left.arrow
      | Go to Round
    .ui.divider
    .ui.header operations
    .item(@click="del")
      i.icon.delete
      | Delete

  .ui.form.segment.basic#form-round(slot="main")
    h2.ui.dividing.header {{formattedTitle}}
    .ui.success.message
      .header Changes saved.
    .ui.error.message

    h3.ui.dividing.header Configuration
    .ui.fields.three
      .ui.field
        label title
        .ui.input
          input(name="title")
      .ui.field
        label start from
        .ui.input
          input(name="beginTime", placeholder="YYYY-MM-DD HH:mm:ss")
      .ui.field
        label end at
        .ui.input
          input(name="endTime", placeholder="YYYY-MM-DD HH:mm:ss")

    //- permit

    // h3.ui.dividing.header Problemset
    // .ui.field
    //   .ui.dropdown.icon.selection.fluid.multiple.search
    //     input(type="hidden", name="problems")
    //     .default.text problems
    //     i.dropdown.icon
    //     .menu
    //       .item(v-for="(value, key) of dropdownProblems", :data-value="key") {{value}}
    // br

    .ui.field
      a.icon.ui.labeled.button.floated.primary.submit
        i.icon.save
        | Save
</template>

<script>
import Vue from 'vue'
import { mapGetters, mapActions } from "vuex";
import moment from 'moment'
import { debug } from 'debug'
import { map, pairsToObj, objToPairs, flatten } from 'prelude-ls'
import window from '@/components/window'

const log = debug('dollast:component:round:modify')

function getFormValues (values) {
  const beginTime = moment(values.beginTime).valueOf()
  const endTime = moment(values.endTime).valueOf()

  return {beginTime, endTime, title: values.title}
}

function setFormValues (round) {
  // log 'new states. setting new values for form...', to-client-fmt problem.to-JS!
  const $form = $('#form-round')
  let {title, beginTime, endTime, problems} = round

  // # probs = map (-> prob-fmt it), probs
  // # probs .= join!

  problems = problems.map(problem => `${problem._id}`)
  $form.form('set values', {
    title: title,
    beginTime: beginTime ? new moment(beginTime).format('YYYY-MM-DD HH:mm:ss') : undefined,
    endTime: endTime ? new moment(endTime).format('YYYY-MM-DD HH:mm:ss') : undefined,
    problems: problems
  })
}

export default {
  data () {
    return {
      round: {
        _id: null,
        problems: []
      }
    }
  },

  computed: {
    dropdownProblems () {
      return this.round.problems.map(x => [x._id, Vue.filter('problem')(x)])
    },

    formattedTitle () {
      if (!this.round._id) {
        return "Create new Round"
      } else {
        return `Round ${this.round._id}. ${this.round.title}`
      }
    }
  },

  components: {
    window
  },

  // methods: (map-actions [\$fetch]) <<<
  //   fetch: ->>
  //     {round} = @$route.params
  //     if round?
  //       @round = await @$fetch method: \GET, url: "round/#{round}"

  //   del: ->>
  //     log \delete
  //     await @$fetch method: \DELETE, url: "round/#{@round._id}"
  //     @$router.go "/round"

  mounted () {
    this.$nextTick(() => {
      const submit = async (e, values) => {
        e.preventDefault()
        const round = getFormValues(values)
        if (this.$route.params.roundId != undefined) {
          round._id = this.$route.params.roundId
        }
        // await @$fetch method: \POST, url: "round", data: round
      }

      $('#form-round').form({
        onSuccess: submit
      })

      if (!this.round._id) {
        // @round.permit =
        //   owner: @user
        //   group: \rounds
        //   access: \rwxr--r--
      }
      setFormValues(this.round)
    })
  },

  // created: ->
  //   @fetch!

  watch: {
    'round._id' () {
      this.$nextTick(() => {
        $('.ui.selection.dropdown').dropdown('refresh')
        setFormValues(this.round)
      })
    }
  }

    // $route: ->
    //   @fetch!

}
</script>
