require! {
  \react/addons : {create-class}
  \react-redux : {connect}
  \../elements : {icon-text}
  \../../actions : {on-get-problem}
  \../utils : U
  \immutable : I
}

log = debug \dollast:component:problem:show

selector = (state) ->
  problem: state.get-in [\problem, \show], I.from-JS do
    outlook: {}
    config: {}

segment-box = create-class do
  display-name: \segment-box
  
  render: ->
    _div class-name: "ui segment",
      _div class-name: "ui top left attached label teal", @props.desc
      @props.children

module.exports = (connect selector) create-class do
  display-name: \prob-show
  
  refresh-mathjax: (root) ->
    MathJax.Hub.Queue [\Typeset, MathJax.Hub]
  
  component-will-mount: (root) ->
    @props.dispatch on-get-problem @props.params.pid, \show
    @refresh-mathjax root
  
  component-did-update: (props, states, root) ->
    @refresh-mathjax root
  
  render: ->
    pid = @props.params.pid
    problem = @props.problem.to-JS!
    #log {problem}
    
    _div class-name: "ui",
      _h1 class-name: "ui centered", "Problem #{pid}. #{problem.outlook.title}"
      _p null, "time limit: #{problem.{}config.time-lmt || ''} space limit: #{problem.{}config.space-lmt || ''}"
      _ segment-box, desc: \description,
        _p mathjax: true, problem.outlook?.desc
      _div class-name: "ui two column grid",
        _div class-name: \row,
          _div class-name: \column,
            _ segment-box, desc: "input format",
              _p null, problem.outlook?.in-fmt # mathjax here
          _div class-name: \column,
            _ segment-box, desc: "output format",
              _p null, problem.outlook?.out-fmt # mathjax here
        _div class-name: \row,
          _div class-name: \column,
            _ segment-box, desc: "sample input",
              _pre null, problem.outlook?.sample-in
          _div class-name: \column,
            _ segment-box, desc: "sample output",
              _pre null, problem.outlook?.sample-out

      _div class-name: "ui divider"

      _ icon-text, 
        class-name: \primary
        href: "#/solution/submit/#{pid}"
        text: \submit
        icon: \rocket
      _ icon-text,
        class-name: \orange
        href: "#/problem/#{pid}/modify"
        text: \modify
        icon: \edit
      _ icon-text,
        class-name: \purple
        href: "#/problem/#{pid}/stat"
        text: \statistics
        icon: "bar chart"
