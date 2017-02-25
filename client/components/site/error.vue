<template lang="jade">
  .ui.modal.small(keep-alive)#error
    .ui.header
      | Error on {{ object }}
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
require! {
  \vue
  \vuex : {map-mutations, map-getters}
  \debug
}

log = debug \dollast:error

module.exports =
  computed: (map-getters [\error]) <<<
    message: ->
      if @error == void
        ""
      else
        "#{@error.message}"

    object: ->
      if @error == void
        ""
      else
        "#{@error.object}"

  mounted: ->
    $modal = $ \#error
    $modal.modal blurring: true .transition \fade
    # if !@error.closable
    #   $modal.modal \setting, \closable, false

  methods: (map-mutations [\resolveError]) <<<
    back: ->
      @resolve-error!
      @$router.go -1

    home: ->
      @resolve-error!
      @$router.push '/'

    ignore: ->
      @resolve-error!

  watch:
    error: (val) ->
      log "new error value", val
      $modal = $ \#error
      $modal.modal \refresh
      if val != void
        $modal.modal \setting, \closable, @error?.closable || false
        $modal.modal \show
      else
        $modal.modal \hide

</script>
