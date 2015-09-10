window.$ = React.create-element
for key, value of React.DOM
  window."$#key" = value

R = React

index = R.create-class do
  render: ->
    $p {}, ""

R.render index
