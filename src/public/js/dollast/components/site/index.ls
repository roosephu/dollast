R = require \react/addons

module.exports = R.create-class do
  dispay-name: \index
  render: ->
    _div {},
      _h1 class-name: "ui dividing header", "welcome"
      _h3 class-name: "ui", "this is dollast, an buggy online judge."
