require! {
  \react/addons : {create-class}
  \react-redux : {connect}
  \../elements : {icon-text}
  \../../actions : {on-get-solution}
  \../utils : U
  \immutable : I
  \react-highlight : highlight
}

log = debug \dollast:component:solution:show

selector = (state) ->
  sol: state.get-in [\solution, \show], I.from-JS do
    final: {}
    results: []

module.exports = (connect selector) create-class do
  display-name: \sol-show
  
  component-will-mount: ->
    @props.dispatch on-get-solution @props.params.sid

  render: ->
    sol = @props.sol.to-JS!

    _div null, 
      _h3 class-name: "ui header", "author: #{sol.user}"
      _h3 class-name: "ui header", "lang: #{sol.lang}"
      _h3 class-name: "ui header", "problem:",
        _span null, sol.prob
      switch sol.final.status
        | \private =>
          _p null, "this code is private"
        | \CE =>
          _div null, 
            _p null, "compile message:"
            _pre null, sol.final.message
        | \running =>
          _div class-name: \ui, \running
        | otherwise =>
          _div null, 
            _div class-name: "ui toggle checkbox",
              _input type: \checkbox,
              _label "Current state: #{if open then \public else \private}"
            _div class-name: \ui,
              _h1 class-name: "ui header dividing", \details
              _table class-name: "ui table segment",
                _thead null,
                  _tr null,
                    _th null, \input
                    _th null, \status
                    _th null, \time
                    _th null, \space
                    _th null, \score
                    _th null, \message
                _tbody null, 
                  for result in sol.results
                    _tr class-name: \positive, key: result.input,
                      _td null, result.input
                      _td null, result.status
                      _td null, result.time
                      _td null, result.space
                      _td null, result.score
                      _td null, result.message
                _tfoot null, 
                  _tr null,
                    _th null, 'final result'
                    _th null, sol.final.status
                    _th null, sol.final.time
                    _th null, sol.final.space
                    _th null, sol.final.score
                    _th null, sol.final.message
      _h1 class-name: "ui header dividing", \code
      _pre null,
        _ highlight, class-name: sol.lang, sol.code
