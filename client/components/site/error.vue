<template lang="jade">
  .ui.basic.modal.small
    //- i.icon.close
    .ui.icon.header
      i.icon.announcement
      | Error on {{ object }}
    .content
      h4 {{ message }}
    .actions
      //- .two.fluid.ui.inverted.buttons
      .ui.red.basic.inverted.button(@click="home")
        i.icon.home
        | Home
      .ui.green.basic.inverted.button(@click="back")
        i.icon.arrow.left
        | Back
</template>

<script lang="vue-livescript">
require! {
  \vue
  \debug
  \co
  \../../actions : {resolve-error}
}

log = debug \dollast:error

module.exports =
  vuex:
    getters:
      error: (.error)
    actions:
      {resolve-error}

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
        "#{@error.type} #{@error.id}"

  ready: ->
    $modal = $ \.modal
    $modal.modal \setting, \closable, false

  methods:
    back: ->
      @resolve-error!
      @$route.router.go window.history.back!

    home: ->
      @resolve-error!
      @$route.router.go '/'

  watch:
    error: (val) ->
      log {val}
      if val != void
        $ \.modal .modal \show
      else
        $ \.modal .modal \hide


</script>
