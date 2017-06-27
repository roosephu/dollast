<template lang="pug">
div
  .ui.dropdown.icon.selection.search#round-selector
    input(type="hidden", name="round")
    i.dropdown.icon
    .default.text round
    .menu
      .item(v-if="round", :data-value="round._id") {{round | round}}
</template>

<script lang="livescript">
require! {
  \vue : {default: vue}
  \debug
}

log = debug \dollast:components:elements:round-selector

module.exports =
  props:
    round: Object

  mounted: ->
    @$next-tick ->
      $ \#round-selector .dropdown do
        data-type: \jsonp
        api-settings:
          on-response: (response) ->
            if !response.data?._id?
              return success: false, results: []
            # log {response}
            round = response.data
            {_id, title} = round
            return results: [value: _id, name: vue.filter(\round) round]
          url: "/api/round/{query}/"
          on-change: (value) ~>
            log {value}

  watch:
    'round': ->
      $ '#round-selector' .dropdown \refresh
</script>
