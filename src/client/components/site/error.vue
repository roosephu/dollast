<template lang="jade">
  .ui.modal.small(keep-alive)#error
    .ui.header
      | Error
      //-  on {{ object }}
    .content
      h4 {{ message }}
    .actions
      .ui.left.floated.button(@click="home")
        i.icon.home
        | Home
      .ui.green.button(@click="back")
        i.icon.arrow.left
        | Back
      .ui.primary.button(@click="ignore")
        i.icon.configure
        | Ignore
</template>

<script>
import { mapMutations, mapGetters } from 'vuex'
import { debug } from 'debug'

const log = debug('dollast:error')

export default {
  computed: {
    message () {
      return this.error && this.error.message
    },

    object () {
      return this.error && this.error.object
    },

    ...mapGetters(['error'])
  },

  mounted () {
    const $modal = $('#error')
    $modal.modal({
      // blurring: true
    }).transition('fade')
  },

  methods: {
    back () {
      this.fixError()
      this.$router.go(-1)
    },

    home () {
      this.fixError()
      this.$router.push('/')
    },

    ignore () {
      this.fixError()
    },

    ...mapMutations(['fixError'])
  },

  watch: {
    error (val) {
      log('new error value', val)
      const $modal = $('#error')
      $modal.modal('refresh')
      if (val != null) {
        $modal.modal('setting', 'closable', this.error.closable || false)
        $modal.modal('show')
      } else {
        $modal.modal('hide')
      }
    }
  }
}
</script>
