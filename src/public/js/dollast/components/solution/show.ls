require! {
  \react : {create-class}
  \react-redux : {connect}
  \../elements : {icon-text}
  \../../actions : {on-get-solution}
  \immutable : I
  \react-highlight : highlight
}

log = debug \dollast:component:solution:show

selector = (state, props) ->
  sol: state.get-in [\db, \solution, props.params.sid, \get], I.from-JS do
    final: {}
    results: []
    prob:
      _id: 0

module.exports = (connect selector) create-class do
  display-name: \sol-show

  component-will-mount: ->
    @props.dispatch on-get-solution @props.params.sid

  render: ->
    sol = @props.sol.to-JS!
    pid = sol.prob._id
    state = if sol.open then \public else \private

    _ \div, null,
      _ \h3, class-name: "ui header", "author: #{sol.user}"
      _ \h3, class-name: "ui header", "lang: #{sol.lang}"
      _ \h3, class-name: "ui header", "problem: #{pid}"

      _ \h1, class-name: "ui header dividing", \code
      _ \pre, null,
        _ highlight, class-name: sol.lang, sol.code
      switch sol.final.status
        | \private =>
          _ \p, null, "this code is private"
        | \CE =>
          _ \div, class-name: "ui segment",
            _ \div, class-name: "ui top attached label", "Error Message"
            _ \pre, null, sol.final.message
        | \running =>
          _ \div, class-name: \ui, \running
        | otherwise =>
          _ \div, null,
            _ \div, class-name: "ui toggle checkbox",
              _ \input, type: \checkbox
              _ \label, "Current state: #state"
            _ \div, class-name: \ui,
              _ \h1, class-name: "ui header dividing", \details
              _ \table, class-name: "ui table segment",
                _ \thead, null,
                  _ \tr, null,
                    _ \th, null, \input
                    _ \th, null, \status
                    _ \th, null, \time
                    _ \th, null, \space
                    _ \th, null, \score
                    _ \th, null, \message
                _ \tbody, null,
                  for result in sol.results
                    _ \tr, class-name: \positive, key: result.input,
                      _ \td, null, result.input
                      _ \td, null, result.status
                      _ \td, null, result.time
                      _ \td, null, result.space
                      _ \td, null, result.score
                      _ \td, null, result.message
                _ \tfoot, null,
                  _ \tr, null,
                    _ \th, null, 'final result'
                    _ \th, null, sol.final.status
                    _ \th, null, sol.final.time
                    _ \th, null, sol.final.space
                    _ \th, null, sol.final.score
                    _ \th, null, sol.final.message
