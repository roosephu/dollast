<template lang="pug">
.ui.dropdown.icon.selection.search#pack-selector
  input(type="hidden", name="pack")
  i.dropdown.icon
  .default.text pack
  .menu
    .item(v-if="pack", :data-value="pack._id") {{pack | pack}}
</template>

<script>
require! {
  \vue
  \debug
}

log = debug \dollast:components:elements:pack-selector

module.exports =
  props:
    pack: Object

  mounted: ->
    @$next-tick ->
      $ \#pack-selector .dropdown do
        data-type: \jsonp
        api-settings:
          on-response: (response) ->
            if !response.data?._id
              return success: false, results: []
            # log {response}
            pack = response.data
            {_id, title} = pack
            return results: [value: _id, name: vue.filter(\pack) pack]
          url: "/api/pack/{query}/"
          on-change: (value) ~>
            log {value}

  watch:
    'pack': ->
      $ '#pack-selector' .dropdown \refresh
</script>
