require! {
  \react : {create-class}
  \react-redux : {connect}
  \immutable : I
  \../elements : {icon-text}
  \../../actions
}

selector = (state) ->
  user: I.from-JS {}

module.exports = create-class do
  display-name: \user-show

  component-did-mount: ->


  render: ->
    uid = @props.params.uid
    _ \div, null,
      _ \h1, class-name: "ui dividing header", "Details of #{uid}"
      _ \h4, null, "registered since"

      _ \h4, null, "privileges"
      _ \h4, null, "problems solved"
      _ \h4, null, "problems created"
      _ \h4, null, "rounds created"
      _ \h4, null, "description"

      _ icon-text,
        class-name: "primary"
        icon: \edit
        text: \modify
        href: "#/user/#{uid}/modify"
