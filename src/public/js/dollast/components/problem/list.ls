require! {
  \react/addons : {create-class}
  \react-redux : {connect}
  \../../actions : {on-refresh-problem-list}
  \../elements : E
  \../utils : U
  \immutable : I
}

log = debug 'dollast:component:problem:list'

link-list = create-class do
  display-name: \link-list
  render: ->
    _div class-name: "ui very relaxed divided link list",
      for elem in @props.list
        _a class-name: "item", href: elem.href, key: elem.href, # "problem/#{prob._id}",
          _div class-name: "ui left floated icon",
            _i class-name: "icon check"
            _i class-name: "icon remove"
          _div class-name: "ui right floated", elem.right #"stat: #{elem.stat}"
          _div class-name: \description, elem.desc # "#{prob._id}. #{prob.outlook.title}"

selector = (state) ->
  prob-list: state.get-in [\problem, \list], I.from-JS []

module.exports = (connect selector) create-class do
  display-name: \prob-list
  
  component-did-mount: ->
    @props.dispatch on-refresh-problem-list!

  render: ->
    prob-list = for prob in @props.prob-list.to-JS!
      href: "#/problem/#{prob._id}"
      right: ''
      desc: prob.outlook.title

    _div class-name: "ui",
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
        href: \#/problem/create
        text: \create
        icon: \plus
