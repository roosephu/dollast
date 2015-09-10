require! {
  \react/addons : R
  \../elements : E
  \../utils : U
  \../../stores/problem : P
}

module.exports = R.create-class do
  display-name: \prob-show
  render: ->
    pid = @props.params.pid
    _ E.ui, null,
      _h1 class-name: "ui centered", "problem: #{pid}"
