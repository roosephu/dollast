require! {
  \react : {create-class}
  \./utils : {get-attr, merge-prop, add-class-name}
  \classnames
}

log = debug \dollast:elements

export labeled-icon = create-class do
  display-name: \labeled-icon
  render: ->
    a-props = get-attr @props, [\href, \onClick, \className, \onValueChange]
    a-props = merge-prop a-props, class-name: "item labeled"
    _ \a, a-props,
      _ \i, class-name: "icon #{@props.icon}"
      @props.text

export icon-text = create-class do
  display-name: "icon-button"
  render: ->
    a-props = get-attr @props, [\href, \onClick, \className, \onValueChange]
    a-props = merge-prop a-props, class-name: "ui icon button labeled"
    # console.log "ap", a-props
    _ \a, a-props,
      _ \i, class-name: "icon #{@props.icon}"
      @props.text

export icon-input = create-class do
  display-name: \icon-input
  render: ->
    div-props = get-attr @props, [\href, \onClick, \className]
    div-props = merge-prop div-props, class-name: "ui input icon"
    # console.log a-props, @props
    _ \div, div-props,
      _ \i, class-name: "icon #{@props.icon}"
      _ \input, @props.input

export ui = create-class do
  display-name: \ui
  render: ->
    props = add-class-name @props, \ui
    # console.log props
    _ \div, props, @props.children

export field = create-class do
  display-name: \field
  render: ->
    props = add-class-name @props, \field
    _ \div, props, @props.children

export tab-menu = create-class do
  display-name: \tab-menu

  component-did-mount: ->
    $ '.filter.menu .item' .tab!
    # console.log $ '.filter.menu .item'

  render: ->
    menu-props = add-class-name @props.menu-props, "filter menu"
    # console.log "menu props", menu-props
    menu =
      _ \div, class-name: "tab", key: \menu,
        _ ui, menu-props,
          for tab in @props.tabs
            tab-prop = add-class-name tab.prop, "item"
            tab-prop = merge-prop tab-prop, "data-tab": tab.tab-name
            if tab.tab-name == @props.active
              tab-prop = add-class-name tab-prop, "active"
            tab-prop.key = tab.tab-name
            _ \a, tab-prop, tab.text

    tabs = for tab in @props.tabs
      prop = class-name: "tab", "data-tab": tab.tab-name
      if tab.tab-name == @props.active
        prop = add-class-name prop, "active"
      prop.key = tab.tab-name
      _ ui, prop, tab.dom

    # console.log "tab-menu", menu, tabs

    _ ui, {}, [menu] ++ tabs

export label-field = create-class do
  display-name: \label-field
  render: ->
    text = delete @props.text
    _ field, @props,
      _ \label, key: \label, text
      @props.children

export dropdown = create-class do
  display-name: \dropdown

  component-did-mount: ->
    $ ".dropdown.ui" .dropdown!

  render: ->
    classes = add-class-name @props, "dropdown"
    _ ui, classes,
      _ \input, type: \hidden, name: @props.name
      _ \div, class-name: "default text", @props.default
      _ \i, class-name: "dropdown icon"
      _ \div, class-name: "menu",
        for key, val of @props.options
          _ \div, class-name: "item", "data-value": key, key: key,
            val

export statistics = create-class do
  display-name: \statistics

  render: ->
    class-name = classnames @props.class-name, "ui statistics"
    _ \div, {class-name},
      for key, val of @props.stat
        _ \div, class-name: \statistic, key: key,
          _ \div, class-name: \value, val
          _ \div, class-name: \label, key

export label-segment = create-class do
  display-name: \label-segment

  render: ->
    class-name = classnames @props.class-name, "ui segment"
    _ \div, class-name: "ui segment",
      _ \div, class-name: "ui top attached label large", @props.text
      @props.children
