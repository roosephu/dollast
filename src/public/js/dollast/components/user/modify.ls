require! {
  \react : {create-class}
  \react-redux : {connect}
  \../elements : {icon-text, label-field, dropdown, icon-input, field}
  \immutable : I
  \prelude-ls : {join}
  \../../utils/privileges
  \../../actions : {on-get-user-privileges, on-update-user}
}

log = debug \dollast:components:user:modify

selector = (state) ->
  user: state.get-in [\user, \privileges], I.from-JS do
    _id: ''
    priv-list: []

module.exports = (connect selector) create-class do
  display-name: \user-modify

  submit: (e) ->
    e.prevent-default!
    $form = $ '#form-user'
    {privileges, old-password, new-password, confirm-password} = $form.form 'get values'
    priv-list = privileges.split ','
    _id = @props.params.uid
    log {old-password, new-password}

    if old-password == "" or new-password == ""
      updated = {_id, priv-list}
    else
      updated = {_id, priv-list, old-password, new-password}

    @props.dispatch on-update-user @props.params.uid, updated

  component-did-mount: ->
    $form = $ '#form-user'
    $form.form do
      on-success: @submit
      on: \blur
      fields:
        old-password:
          identifier: \oldPassword
          optional: true
          rules: \isPassword
        new-password:
          identifier: \newPassword
          optional: true
          rules: \isPassword
        confirmation:
          identifier: \confirmPassword
          optional: true
          rules: [\isPassword, "match[newPassword]"]
    @props.dispatch on-get-user-privileges @props.params.uid

  component-will-update: (next-props, next-state) ->
    user = next-props.user.to-JS!

    $form = $ '#form-user'
    $form.form 'set values', privileges: user.priv-list

  render: ->
    user = @props.user.to-JS!

    _ \div, class-name: "ui form", id: "form-user",
      _ \h2, null, "#{user._id}"
      _ label-field, text: \privileges,
        _ dropdown,
          class-name: "selection search multiple fluid"
          name: \privileges
          default: "select proper access"
          options: privileges

      _ \h3, class-name: "ui dividing header", "Password"
      _ \div, class-name: "four fields wide",
        _ label-field, text: "old password",
          _ icon-input,
            class-name: "left"
            icon: \lock
            input:
              placeholder: "old password"
              name: \oldPassword
              type: \password
      _ \div, class-name: "four fields wide",
        _ label-field, text: "new password",
          _ icon-input,
            class-name: "left"
            icon: \lock
            input:
              placeholder: "new password"
              name: \newPassword
              type: \password
      _ \div, class-name: "four fields wide",
        _ label-field, text: "confirm new password",
          _ icon-input,
            class-name: "left"
            icon: \lock
            input:
              placeholder: "confirmation"
              name: \confirmPassword
              type: \password

      _ icon-text,
        class-name: "submit primary"
        icon: \save
        text: \submit
