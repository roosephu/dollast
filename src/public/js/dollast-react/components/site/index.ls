R = require \react

module.exports = R.create-class do
  dispay-name: \index
  render: ->
    _ \div, {},
      _ \h1, class-name: "ui dividing header", "welcome"
      _ \h3, class-name: "ui", "this is dollast, an buggy online judge."
