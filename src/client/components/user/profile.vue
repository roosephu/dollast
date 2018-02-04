<template lang="jade">
window
  .menu(slot="config")
    .ui.header links
    router-link.item(:to="{name: 'submissions', query: {user: user}}")
      i.icon
      | All submissions
    .ui.divider
    .ui.header operations
    a.item(:href="'#/user/' + user + '/update'")
      i.icon.edit
      | Update

  .ui.basic.segment(:class="{loading: isLoading}", slot="main")
    h1.ui.dividing.header Details of {{user}}
    .ui.segment
      .ui.top.attached.label.large registered since
      p {{registerDate}}

    .ui.segment
      .ui.large.top.attached.label description
      p {{profile.description}}

    .ui.segment
      .ui.top.attached.label.large Groups
      .ui.olive.label(v-for="group in profile.groups") {{group}}

    .ui.segment
      .ui.top.attached.label.large Problems solved
      .ui.relaxed.divided.link.list
        .item(v-for="prob in solvedProblems")
          .description
            problem(:prob="prob")

    .ui.segment
      .ui.top.attached.label.large Problems owned
      .ui.relaxed.divided.link.list
        .item(v-for="prob in ownedProblems")
          .description
            problem(:prob="prob")

    .ui.segment
      .ui.top.attached.label.large Rounds owned
      .ui.relaxed.divided.link.list
        .item(v-for="round in ownedRounds")
          .ui.right.floated
            .ui.label {{round.beginTime | time}}
            | to
            .ui.label {{round.endTime | time}}
          .description
            round(:round="round")
</template>

<script>
import { mapActions, mapGetters } from 'vuex'
import moment from 'moment'
import { debug } from 'debug'
import naturalSort from 'javascript-natural-sort'
import window from '@/components/window'
import problem from '@/components/format/problem'
import round from '@/components/format/round'

const log = debug('dollast:components:user:profile')

function naturalSortBy (f) {
  return (a, b) => {
    naturalSort(f(a), f(b))
  }
}

export default {
  data () {
    return {
      user: this.$route.params.userId,
      profile: {},
      solvedProblems: [],
      ownedProblems: [],
      ownedRounds: []
    }
  },

  computed: {
    registerDate () {
      if (this.profile.date) {
        return moment(this.profile.date).format('MMMM Do YYYY')
      } else {
        return ''
      }
    },

    ...mapGetters(['isLoading'])
  },

  // created: ->
  //   @fetch!

  // watch:
  //   $route: ->
  //     @fetch!

  // methods: (map-actions [\$fetch]) <<<
  //   fetch: ->>
  //     profile = await @$fetch method: \GET, url: "user/#{@$route.params.user}"
  //     profile.solved-problems .= sort natural-sort-by (._id)
  //     profile.owned-problems .= sort natural-sort-by (._id)
  //     profile.owned-rounds .= sort natural-sort-by (._id)

  //     @ <<< {profile}

  components: {
    window,
    problem,
    round
  }
}
</script>
