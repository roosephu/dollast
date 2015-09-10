R = require \react/addons
U = require \./utils

export icon-text = R.create-class do
  display-name: "icon-button"
  render: ->
    a-props = U.get-attr @props, [\href, \on-click, \className]
    a-props = U.merge-prop a-props, class-name: "ui icon button labeled"
    # console.log "ap", a-props
    _a a-props,
      _i class-name: "icon #{@props.icon}"
      @props.text

export icon-input = R.create-class do
  display-name: \icon-input
  render: ->
    div-props = U.get-attr @props, [\href, \on-click, \className]
    div-props = U.merge-prop div-props, class-name: "ui input icon"
    # console.log a-props, @props
    _div div-props,
      _i class-name: "icon #{@props.icon}"
      _input @props.input

export ui = R.create-class do
  display-name: \ui
  render: ->
    props = U.add-class-name @props, \ui
    # console.log props
    _div props, @props.children

export field = R.create-class do
  display-name: \field
  render: ->
    props = U.add-class-name @props, \field
    _div props, @props.children

export tab-menu = R.create-class do
  display-name: \tab-menu

  component-did-mount: ->
    $ '.filter.menu .item' .tab!
    # console.log $ '.filter.menu .item'

  render: ->
    menu-props = U.add-class-name @props.menu-props, "filter menu"
    # console.log "menu props", menu-props
    menu =
      _div class-name: "tab",
        _ ui, menu-props,
          for tab in @props.tabs
            tab-prop = U.add-class-name tab.prop, "item"
            tab-prop = U.merge-prop tab-prop, "data-tab": tab.tab-name
            if tab.tab-name == @props.active
              tab-prop = U.add-class-name tab-prop, "active"
            _a tab-prop, tab.text

    tabs = for tab in @props.tabs
      prop = class-name: "tab", "data-tab": tab.tab-name
      if tab.tab-name == @props.active
        prop = U.add-class-name prop, "active"
      _ ui, prop, tab.dom

    # console.log "tab-menu", menu, tabs

    _ ui, {}, [menu] ++ tabs

export label-field = R.create-class do
  display-name: \label-field
  render: ->
    text = delete @props.text
    _ field, @props,
      [_label {}, text] ++ @props.children

export dropdown = R.create-class do
  display-name: \dropdown

  component-did-mount: ->
    $ ".dropdown.ui" .dropdown!

  render: ->
    ui-props = U.add-class-name @props.ui, "dropdown selection"
    _ ui, ui-props,
      _input type: \hidden, name: @props.name
      _i class-name: "dropdown icon"
      _div class-name: "default text", @props.default
      _div class-name: "menu",
        for key, val of @props.options
          _div class-name: "item", "data-value": key, val
