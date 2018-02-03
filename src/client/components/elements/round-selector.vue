<template lang="pug">
div
  .ui.dropdown.icon.selection.search#round-selector
    input(type="hidden", name="round")
    i.dropdown.icon
    .default.text round
    .menu
      .item(v-if="round", :data-value="round._id") {{round | round}}
</template>

<script>
import Vue from 'vue'
import { debug } from 'debug'

const log = debug('dollast:components:elements:round-selector')

export default {
  props: {
    round: Object
  },

  mounted () {
    this.$nextTick(() => {
      $('#round-selector').dropdown({
        dataType: 'jsonp',
        apiSettings: {
          onResponse (response) {
            if (!response.data._id) {
              return {
                success: false,
                results: []
              }
            }
            const round = response.data
            const {_id, title} = round
            return {
              results: [{
                value: _id,
                name: vue.filter('round')(round)
              }]
            }
          },
          url: "/api/round/{query}/",
          onChange (value) {
            log({value})
          }
        }
      })
    })
  },

  watch: {
    round () {
      $('#round-selector').dropdown('refresh')
    }
  }
}
</script>
