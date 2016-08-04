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

<script lang="livescript">
require! {
  \vue
  \debug
  \co
  \../../actions
}

log = debug \dollast:error

module.exports =
  vuex:
    getters:
      error: (.error)
    actions:
      actions{resolve-error}

  computed:
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

  ready: ->
    $modal = $ \#error
    $modal.modal blurring: true .transition \fade
    # if !@error.closable
    #   $modal.modal \setting, \closable, false

  methods:
    back: ->
      @resolve-error!
      @$route.router.go window.history.back!

    home: ->
      @resolve-error!
      @$route.router.go '/'
    
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
