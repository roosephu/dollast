require! {
  \react : {create-class}
  \react-redux : {connect}
  \immutable : I
  \../elements : {dropdown, icon-text, rnd-link}
  \../../actions : {on-get-rounds-list}
  \moment
}

log = debug \dollast:component:round:list

selector = (state) ->
  rounds: state.get-in [\round, \list], I.from-JS []

module.exports = (connect selector) create-class do
  display-name: \rnd-list

  filter: (value, text, $choice) ->
    log {value, text, $choice}

  component-will-mount: ->
    @props.dispatch on-get-rounds-list!

  component-did-mount: ->
    $filter = $ '.dropdown'
    log $filter
    $filter.dropdown do
      on: \hover
      on-change: @filter
    $filter.dropdown 'set text', \all

  render: ->
    rounds = @props.rounds.to-JS!

    _ \div, null,
      _ \div, class-name: \ui,
        _ \h1, class-name: "ui header dividing", \rounds
        _ dropdown,
          class-name: "floated pointing button labeled icon"
          name: \filter
          default: "please select filter"
          options: {\all, \past, \running, \pending}

        _ icon-text,
          class-name: "launch primary right floated"
          text: \create
          icon: \plus
          href: '#/round/create'
      _ \div, class-name: \ui,
        _ \div, class-name: "ui very relaxed divided link list",
          for rnd in rounds
            style =
              if moment!.is-before rnd.beg-time
                \green
              else if moment!.is-after rnd.end-time
                \grey
              else
                \red
            _ \div, class-name: "item", href: rnd.href, key: "round/#{rnd._id}",
              # _ \div, class-name: "ui left floated icon",
              #   _ \i, class-name: "icon remove"
              _ \div, class-name: "ui right floated",
                " from "
                _ \div, class-name: "ui label #{style}",
                  moment rnd.beg-time .format 'YYYY-MM-DD hh:mm:ss'
                " to "
                _ \div, class-name: "ui label #{style}",
                  moment rnd.end-time .format 'YYYY-MM-DD hh:mm:ss'
                # 'Registered: '
              _ \div, class-name: \description,
                _ rnd-link, rid: rnd._id, title: rnd.title
