require! {
  \react : {create-class}
  \react-redux : {connect}
  \../elements : {icon-text, label-field, dropdown, icon-input, field}
  \../loading : {loading}
  \immutable : I
  \prelude-ls : {join}
  \../../utils/privileges
  \../../actions : {on-get-user-profile, on-update-user}
}

log = debug \dollast:components:user:modify

selector = (state, props) ->
  user: state.get-in [\db, \user, props.params.uid, \get], I.from-JS do
    profile:
      groups: []
    solved-problems: []
    owned-problems: []
    owned-rounds: []

module.exports = (connect selector) create-class do
  display-name: \user-modify

  submit: (e) ->
    e.prevent-default!
    $form = $ '#form-user'
    {privileges, old-password, new-password, confirm-password, desc} = $form.form 'get values'
    groups = privileges.split ','
    _id = @props.params.uid

    if old-password == "" or new-password == ""
      updated = {_id, groups, desc}
    else
      updated = {_id, groups, desc, old-password, new-password}

    @props.dispatch on-update-user @props.params.uid, updated

  component-did-mount: ->
    @props.dispatch on-get-user-profile @props.params.uid
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

  component-will-update: (next-props, next-state) ->
    user = next-props.user.to-JS!

    $form = $ '#form-user'
    $form.form 'set values', privileges: user.profile.groups

  render: ->
    user = @props.user.to-JS!
    # return _ loading if user.loading

    _ \div, class-name: "ui form", id: "form-user",
      _ \h2, null, "#{user.profile._id}"
      _ label-field, text: \privileges,
        _ dropdown,
          class-name: "selection search multiple fluid"
          name: \privileges
          default: "select proper access"
          options: privileges

      _ \h3, class-name: "ui dividing header", "Description"
      _ \div, class-name: "ui two fields",
        _ label-field, text: "describe yourself",
          _ \textarea, name: \desc

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
