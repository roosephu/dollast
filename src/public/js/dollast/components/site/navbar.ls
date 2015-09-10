require! {
  \react/addons : R
  \../elements : E
  \../../stores/sess
}

labeled-icon = R.create-class do
  display-name: \labeled-icon
  render: ->
    _a class-name: "item labeled", href: @props.href,
      _i class-name: "icon #{@props.icon}"
      @props.text

navbar-user-state = R.create-class do
  display-name: \navbar-user-state

  logout: ->
    sess.actions.logout!

  render: ->
    uid = @props.uid
    search = _div class-name: \item,
      _ E.icon-input,
        icon: "search link"
        input:
          placeholder: "ID or Search"
        class-name: "inverted small"
    if uid != ""
      _div class-name: "right menu",
        search
        _ labeled-icon,
          icon: \user
          text: @props.uid
          href: "#/user/#{uid}"
        _ labeled-icon,
          icon: "sign out"
          text: "Logout"
          href: '#'
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

module.exports = R.create-class do
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
        _ navbar-user-state, uid: @props.uid

    # _p {}, @state.sess.uid
