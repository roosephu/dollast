require! {
  \react : {create-class}
  \react-redux : {connect}
  \../elements : {icon-text}
  \../format : {prob-link, round-time}
  \../../actions : {on-get-round}
  \immutable : I
}

log = debug \dollast:component:round:show

selector = (state, props) ->
  round: state.get-in [\db, \round, props.params.rid, \get], I.from-JS do
    probs: []
    beg-time: "1960-01-01 00:00:00"
    end-time: "1960-01-01 00:00:00"

module.exports = (connect selector) create-class do
  display-name: \rnd-show

  component-did-mount: ->
    rid = @props.params.rid
    @props.dispatch on-get-round rid, \show

  render: ->
    rnd = @props.round.to-JS!

    _ \div, null,
      _ \h1, class-name: "ui dividing header", "Round #{rnd._id}. #{rnd.title}"
      _ round-time, rnd{beg-time, end-time}

      if rnd.started
        _ \div, class-name: "ui segment",
          _ \h2, null, \Problemset
          _ \div, class-name: "ui relaxed divided link list",
            for prob in rnd.probs
              _ \div, class-name: "item", key: "problem/#{prob._id}",
                # _ \div, class-name: "ui left floated icon",
                #   _ \i, class-name: "icon remove"
                # _ \div, class-name: "ui right floated",
                #   " from "
                #   _ \div, class-name: "ui label #{style}",
                #     moment rnd.beg-time .format 'YYYY-MM-DD hh:mm:ss'
                #   " to "
                #   _ \div, class-name: "ui label #{style}",
                #     moment rnd.end-time .format 'YYYY-MM-DD hh:mm:ss'
                  # 'Registered: '
                _ \div, class-name: "ui right floated", "??"
                _ \div, class-name: \description,
                  _ prob-link, {prob}

      else
        _ \p, "Sorry, this round has not started."

      _ \div, null,
        if rnd.started
          _ icon-text,
            class-name: \purple
            text: \board
            icon: \trophy
            href: "#/round/#{rnd._id}/board"

        _ icon-text,
          class-name: \orange
          icon: \edit
          text: \modify
          href: "#/round/#{rnd._id}/modify"
