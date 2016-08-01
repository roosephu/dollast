<template lang="jade">
  .ui.modal.small(keep-alive)#error
    .ui.header
      | Error on {{ object }}
    .content
      h4 {{ message }}
    .actions
      .ui.red.basic.button(@click="home")
        i.icon.home
        | Home
      .ui.green.basic.button(@click="back")
        i.icon.arrow.left
        | Back
      .ui.green.basic.button(@click="ignore")
        i.icon.configure
        | Ignore
</template>

<script lang="vue-livescript">
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
        "#{@error.detail}"

    object: ->
      if @error == void
        ""
      else
        "#{@error.type} #{@error._id}"

  ready: ->
    $modal = $ \#error
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
