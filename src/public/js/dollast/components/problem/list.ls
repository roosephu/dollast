require! {
  \react : {create-class}
  \react-redux : {connect}
  \../../actions : {on-refresh-problem-list}
  \../elements : {icon-text, tab-menu, dropdown, loading-segment}
  \../format : {prob-link}
  \immutable : {from-JS}
  \classnames
}

log = debug 'dollast:component:problem:list'

link-list = create-class do
  display-name: \link-list
  render: ->
    _ \div, class-name: "ui divided link list",
      for elem in @props.list
        _ \a, class-name: "item", href: elem.href, key: elem.href, # "problem/#{prob._id}",
          _ \div, class-name: "ui left floated icon",
            _ \i, class-name: "icon check"
            _ \i, class-name: "icon remove"
          _ \div, class-name: "ui right floated", elem.right #"stat: #{elem.stat}"
          _ \div, class-name: \description, elem.desc # "#{prob._id}. #{prob.outlook.title}"

selector = (state) ->
  problems: state.get-in [\db, \problem, \get], from-JS []
  status: state.get-in [\form, \problem, \get], \init

module.exports = (connect selector) create-class do
  display-name: \prob-list

  filter: (value, text, $choice) ->
    log {value, text, $choice}

  component-did-mount: ->
    @props.dispatch on-refresh-problem-list!
    $filter = $ '.dropdown'
    $filter.dropdown do
      on: \hover
      on-change: @filter
    $filter.dropdown 'set text', \all

  render: ->
    # prob-list = for prob in @props.prob-list.to-JS!
    #   href: "#/problem/#{prob._id}"
    #   right: ''
    #   desc: prob.outlook.title
    problems = @props.problems.to-JS!

    _ \div, class-name: "ui",
      _ \h1, class-name: "ui header dividing", "problem list"
      _ dropdown,
        class-name: "floated pointing button labeled icon"
        name: \filter
        default: "please select filter"
        options: {\all, \past, \running, \pending}
      _ icon-text,
        class-name: "right floated primary labeled"
        href: '#/problem/create'
        text: \create
        icon: \plus

      _ loading-segment, @props{status},
        _ \div, class-name: "ui very relaxed divided link list",
          for prob in problems
            # log {prob}
            id = prob._id
            _ \div, class-name: "item", key: "problem/#{id}",
              # _ \div, class-name: "ui left floated icon",
              #   _ \i, class-name: "icon remove"
              _ \div, class-name: "ui right floated",
                "??"
                # _ round-time, rnd{beg-time, end-time}
                # 'Registered: '
              _ \div, class-name: \description,
                _ prob-link, {prob}

      # _ tab-menu,
      #   menu-props: class-name: "secondary pointing"
      #   active: \all
      #   tabs:
      #     * tab-name: \all
      #       text: \All
      #       prop: class-name: \blue
      #       dom: _ link-list, list: prob-list
      #     * tab-name: \solved
      #       text: \Solved
      #       prop: class-name: \green
      #       dom: _ link-list, list: prob-list
      #     * tab-name: \unsolved
      #       text: \Unsolved
      #       prop: class-name: \red
      #       dom: _ link-list, list: prob-list
