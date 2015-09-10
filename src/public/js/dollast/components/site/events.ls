require! {
 \react/addons : R
 \../elements : E
 \../../stores/events : V
 reflux
}

module.exports = R.create-class do
  mixins: [reflux.connect V.store, "events"]
  \display-name: \events-list
  render: ->
