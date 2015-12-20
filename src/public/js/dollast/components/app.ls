require! {
  \react/addons : {create-class}
  \react-redux : {connect}
  \../actions : {on-logout, on-load-from-token}
  \../components/elements : E
  \../components/site/navbar
  \../components/site/footer
}

log = debug \dollast:component:app

map-state-to-props = (state) ->
  session:
    state.get \session

module.exports = (connect map-state-to-props) create-class do
  # mixins: [reflux.connect sess.store, \uid]
  display-name: \dollast
  
  component-will-mount: ->
    @props.dispatch on-load-from-token local-storage.token

  render: ->
    #log @props.session.get \uid
    {dispatch} = @props

    _div class-name: "ui grid",
      _ navbar, 
        uid: @props.session.get \uid
        on-logout: ->
          dispatch on-logout!
      _div class-name: "row",
        _div class-name: "three wide column"
        _div class-name: "ten wide column",
          @props.children
        # _div class-name: "three wide column",
        #   _ events
      _div class-name: "row",
        # _div class-name: "twelve wide column centered",
        _ footer
