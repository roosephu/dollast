# @cjsx React.DOM

require! {
  \./custom
  \co
  \reflux
  \react/addons : R
  \react-router : T
  \./components/elements : E
  \./components/routes
  \./components/site/navbar
  \./components/site/footer
  \./stores/sess
}

# events = require \./components/site/events

sess.actions.load-token!

app = R.create-class do
  mixins: [reflux.connect sess.store, \uid]
  display-name: \dollast

  render: ->
    console.log @state

    _div class-name: "ui grid",
      _ navbar, @state.uid
      _div class-name: "row",
        _div class-name: "three wide column"
        _div class-name: "ten wide column",
          _ T.Route-handler
        # _div class-name: "three wide column",
        #   _ events
      _div class-name: "row",
        # _div class-name: "twelve wide column centered",
        _ footer

T.run do
  routes app
  (root) ->
    R.render do
      _ root
      document.get-element-by-id \content
