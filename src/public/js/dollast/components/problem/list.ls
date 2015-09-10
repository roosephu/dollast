require! {
  \react/addons : R
  \../elements : E
  \../utils : U
}

link-list = R.create-class do
  display-name: \link-list
  render: ->
    _div class-name: "ui very relaxed divided link list",
      for elem in @props.list
        _a class-name: "item", href: elem.href, # "problem/#{prob._id}",
          _div class-name: "ui left floated icon",
            _i class-name: "icon check"
            _i class-name: "icon remove"
          _div class-name: "ui right floated", elem.right #"stat: #{elem.stat}"
          _div class-name: \description, elem.desc # "#{prob._id}. #{prob.outlook.title}"

module.exports = R.create-class do
  display-name: \prob-list

  render: ->
    prob-list =
      * href: '#/problem/1'
        right: 'stat: ac 1'
        desc: 'A+B problem'
      ...

    _ E.ui, {},
      _h1 class-name: "ui header dividing", "problem list"

      _ E.tab-menu,
        menu-props: class-name: "secondary pointing"
        active: \all
        tabs:
          * tab-name: \all
            text: \All
            prop: class-name: \blue
            dom: _ link-list, list: prob-list
          * tab-name: \solved
            text: \Solved
            prop: class-name: \green
            dom: _ link-list, list: prob-list
          * tab-name: \unsolved
            text: \Unsolved
            prop: class-name: \red
            dom: _ link-list, list: prob-list

      _ E.icon-text,
        class-name: "right floated launch primary labeled"
        href: '#/problem/create'
        text: "create"
        icon: "plus"
