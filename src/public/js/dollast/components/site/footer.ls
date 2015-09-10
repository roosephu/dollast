require! {
  \react/addons : R
  \../elements : E
}

module.exports = R.create-class do
  display-name: \footer
  render: ->
    _ E.ui, class-name: "divider grid horizontal",
      "Yuping Luo @ 2015"
