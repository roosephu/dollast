require! {
  \react : {create-class}
}

module.exports = create-class do
  display-name: \footer
  render: ->
    _ \div, class-name: "ui divider horizontal",
      "Yuping Luo @ 2015"
