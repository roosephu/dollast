require! {
  \react/addons : {create-class}
  \../elements : {labeled-icon, icon-input}
}

log = debug \dollast:navbar

navbar-user-state = create-class do
  display-name: \navbar-user-state

  render: ->
    uid = @props.uid
    search = _div class-name: \item,
      _ icon-input,
        icon: "search link"
        input:
          placeholder: "ID or Search"
        class-name: "inverted small"
    if uid
      _div class-name: "right menu",
        search
        _ labeled-icon,
          icon: \user
          text: @props.uid
          href: "#/user/#{uid}"
        _ labeled-icon,
          icon: "sign out"
          text: "Logout"
          on-click: (e) ~>
            e.prevent-default!
            @props.on-logout!
    else
      _div class-name: "right menu",
        search
        _ labeled-icon,
          icon: "sign in"
          text: \Login
          href: "#/login"
        _ labeled-icon,
          icon: \signup
          text: \Register
          href: "#/user/register"

module.exports = create-class do
  display-name: \navbar

  render: ->
    _div class-name: "row",
      # _div class-name: "ui segment",
      _div class-name: "ui blue inverted page grid borderless menu",
        _div class-name: "header item", \dollast
        _ labeled-icon,
          icon: \home
          text: \Home
          href: "#/"
        _ labeled-icon,
          icon: \browser
          text: \Problem
          href: "#/problem"
        _ labeled-icon,
          icon: "info circle"
          text: \Status
          href: "#/solution"
        _ labeled-icon,
          icon: \user
          text: \Contest
          href: "#/round"
        _ labeled-icon,
          icon: "help circle"
          text: \About
          href: "#/about"
        _ navbar-user-state, 
          uid: @props.uid
          on-logout: @props.on-logout

    # _p {}, @state.sess.uid
