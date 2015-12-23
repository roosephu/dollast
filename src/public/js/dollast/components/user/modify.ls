require! {
  \react : {create-class}
  \react-redux : {connect}
  \../elements : {icon-text}
  \immutable : I
}

selector = (state) ->
  user: I.from-JS do
    id: ''
    priv-list: []

module.exports = (connect selector) create-class do
  display-name: \user-modify

  

  render: ->
    user = @props.user.to-JS!

    _ \div, class-name: "ui form",
      _ \p, null, "user id: #{user.id}"
      _ \div, null,
        _ \ul, null,
          for priv in user.priv-list
            _ \li, null,
              \priv,
              _ \input, type: \button, on-click: @remove, value: remove
      _ icon-text,
        class-name: "submit primary"
        icon: \save
        text: \submit
