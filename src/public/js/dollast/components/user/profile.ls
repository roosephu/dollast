require! {
  \react : {create-class}
  \react-redux : {connect}
  \immutable : I
  \../elements : {icon-text, label-segment}
  \../format : {round-time, rnd-link, prob-link}
  \../../actions : {on-get-user-profile}
  \../../utils/privileges
}

log = debug \dollast:component:user:profile


selector = (state, props) ->
  uid = if props.params.uid then that else state.get-in [\session, \uid]

  uid: uid
  user: state.get-in [\db, \user, uid, \get] I.from-JS do
    profile:
      groups: []
    solved-problems: []
    owned-problems: []
    owned-rounds: []

module.exports = (connect selector) create-class do
  display-name: \user-show

  component-did-mount: ->
    @props.dispatch on-get-user-profile @props.uid

  render: ->
    uid = @props.uid
    user = @props.user.to-JS!

    _ \div, null,
      _ \h1, class-name: "ui dividing header", "Details of #{uid}"

      _ label-segment, text: "registered since"

      # _ \h4, null, "description"
      _ \div, class-name: "ui segment",
        _ \div, class-name: "ui large top attached label", "description"
        _ \div, null, user.profile?.desc

      # _ \h4, null, "groups"
      _ label-segment, text: "Groups",
        _ \div, class-name: "ui relaxed ivided link list",
          for group in user.profile.groups
            _ \div, class-name: \item, key: group,
              _ \div, class-name: \description, privileges[group]
          # _ \div, null, "#{user.profile.groups}"

      # _ \h4, null, "problems solved"
      _ label-segment, text: "Problems solved",
        _ \div, null, "#{JSON.stringify user.solved-problems}"

      # _ \h4, null, "problems owned"
      _ label-segment, text: "Problems owned",
        _ \div, class-name: "ui very relaxed divided link list",
          for prob in user.owned-problems
            _ \div, class-name: "item", key: "problem/#{prob._id}",
              _ \div, class-name: \description,
                _ prob-link, {prob}

      # _ \h4, null, "rounds owned"
      _ label-segment, text: "Rounds owned",
        _ \div, class-name: "ui very relaxed divided link list",
          for rnd in user.owned-rounds
            _ \div, class-name: "item", key: "round/#{rnd._id}",
              _ \div, class-name: "ui right floated",
                _ round-time, rnd{beg-time, end-time}
              _ \div, class-name: \description,
                _ rnd-link, {rnd}

      # _ \div, null, "#{JSON.stringify user.owned-rounds}"


      _ icon-text,
        class-name: "primary"
        icon: \edit
        text: \modify
        href: "#/user/#{uid}/modify"
