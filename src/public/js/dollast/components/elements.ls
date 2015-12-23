require! {
  \react : {create-class}
  \./utils : U
  \classnames
  \moment
}

export labeled-icon = create-class do
  display-name: \labeled-icon
  render: ->
    a-props = U.get-attr @props, [\href, \onClick, \className, \onValueChange]
    a-props = U.merge-prop a-props, class-name: "item labeled"
    _ \a, a-props,
      _ \i, class-name: "icon #{@props.icon}"
      @props.text

export icon-text = create-class do
  display-name: "icon-button"
  render: ->
    a-props = U.get-attr @props, [\href, \onClick, \className, \onValueChange]
    a-props = U.merge-prop a-props, class-name: "ui icon button labeled"
    # console.log "ap", a-props
    _ \a, a-props,
      _ \i, class-name: "icon #{@props.icon}"
      @props.text

export icon-input = create-class do
  display-name: \icon-input
  render: ->
    div-props = U.get-attr @props, [\href, \onClick, \className]
    div-props = U.merge-prop div-props, class-name: "ui input icon"
    # console.log a-props, @props
    _ \div, div-props,
      _ \i, class-name: "icon #{@props.icon}"
      _ \input, @props.input

export ui = create-class do
  display-name: \ui
  render: ->
    props = U.add-class-name @props, \ui
    # console.log props
    _ \div, props, @props.children

export field = create-class do
  display-name: \field
  render: ->
    props = U.add-class-name @props, \field
    _ \div, props, @props.children

export tab-menu = create-class do
  display-name: \tab-menu

  component-did-mount: ->
    $ '.filter.menu .item' .tab!
    # console.log $ '.filter.menu .item'

  render: ->
    menu-props = U.add-class-name @props.menu-props, "filter menu"
    # console.log "menu props", menu-props
    menu =
      _ \div, class-name: "tab", key: \menu,
        _ ui, menu-props,
          for tab in @props.tabs
            tab-prop = U.add-class-name tab.prop, "item"
            tab-prop = U.merge-prop tab-prop, "data-tab": tab.tab-name
            if tab.tab-name == @props.active
              tab-prop = U.add-class-name tab-prop, "active"
            tab-prop.key = tab.tab-name
            _ \a, tab-prop, tab.text

    tabs = for tab in @props.tabs
      prop = class-name: "tab", "data-tab": tab.tab-name
      if tab.tab-name == @props.active
        prop = U.add-class-name prop, "active"
      prop.key = tab.tab-name
      _ ui, prop, tab.dom

    # console.log "tab-menu", menu, tabs

    _ ui, {}, [menu] ++ tabs

export label-field = create-class do
  display-name: \label-field
  render: ->
    text = delete @props.text
    _ field, @props,
      [_ \label, {}, text] ++ @props.children

export dropdown = create-class do
  display-name: \dropdown

  component-did-mount: ->
    $ ".dropdown.ui" .dropdown!

  render: ->
    ui-props = U.add-class-name @props, "dropdown"
    _ ui, ui-props,
      _ \input, type: \hidden, name: @props.name
      _ \div, class-name: "default text", @props.default
      _ \i, class-name: "dropdown icon"
      _ \div, class-name: "menu",
        for key, val of @props.options
          _ \div, class-name: "item", "data-value": key, key: key,
            val

export code-link = create-class do
  display-name: \code

  render: ->
    class-name = classnames @props.class-name, 'green'
    _ icon-text,
      class-name: class-name
      icon: \code
      text: @props.text || "#{@props.sid}"
      href: "#/solution/#{@props.sid}"

export prob-link = create-class do
  display-name: \problem

  render: ->
    class-name = classnames @props.class-name, 'brown'
    _ icon-text,
      class-name: class-name
      icon: \puzzle
      text: "#{@props.pid}. #{@props.title}"
      href: "#/problem/#{@props.pid}"

export rnd-link = create-class do
  display-name: \round

  render: ->
    class-name = classnames @props.class-name, 'teal'
    _ icon-text,
      class-name: class-name
      icon: \idea
      text: "#{@props.rid}. #{@props.title}"
      href: "#/round/#{@props.rid}"

export user-link = create-class do
  display-name: \user

  render: ->
    class-name = classnames @props.class-name, ''
    _ icon-text,
      class-name: class-name
      icon: \user
      text: "#{@props.user}"
      href: "#/user/#{@props.user}"

export round-time = create-class do
  display-name: \round-time

  render: ->
    style =
      if moment!.is-before @props.beg-time
        \green
      else if moment!.is-after @props.end-time
        \grey
      else
        \red
    _ \div, null,
      " from "
      _ \div, class-name: "ui label #{style}",
        moment @props.beg-time .format 'YYYY-MM-DD hh:mm:ss'
      " to "
      _ \div, class-name: "ui label #{style}",
        moment @props.end-time .format 'YYYY-MM-DD hh:mm:ss'
