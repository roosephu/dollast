require! {
  \react : {create-class}
  \react-redux : {connect}
  \../elements : {icon-text, loading-segment}
  \../../actions : {on-get-problem}
  \immutable : {from-JS}
}

log = debug \dollast:component:problem:show


selector = (state, props) ->
  default-prop = from-JS do
    status: \init
    data:
      outlook: {}
      config:
        time-lmt: 0
        space-lmt: 0
      permit:
        owner: ''
        group: ''
  problem: default-prop.merge-deep state.get-in [\db, \problem, props.params.pid, \get]

segment-box = create-class do
  display-name: \segment-box

  render: ->
    _ \div, class-name: "ui segment",
      _ \div, class-name: "ui top left attached label teal", @props.desc
      @props.children

module.exports = (connect selector) create-class do
  display-name: \prob-show

  refresh-mathjax: (root) ->
    MathJax.Hub.Queue [\Typeset, MathJax.Hub]

  component-did-mount: (root) ->
    @props.dispatch on-get-problem @props.params.pid
    @refresh-mathjax root

  component-did-update: (props, states, root) ->
    @refresh-mathjax root

  render: ->
    pid = @props.params.pid
    {status, data: problem} = @props.problem.to-JS!
    #log {problem}

    _ \div, null,
      _ \h1, class-name: "ui dividing header", "Problem #{pid}. #{problem.outlook.title}"

      _ loading-segment, {status},
        # _ \p, null, "time limit: #{problem.{}config.time-lmt || ''} space limit: #{problem.{}config.space-lmt || ''}"
        _ \div, class-name: "ui olive labels",
          _ \div, class-name: "ui label",
            "#{problem.config.time-lmt} s"
            _ \div, class-name: "detail", "time limit"
          _ \div, class-name: "ui label",
            "#{problem.config.space-lmt} MB"
            _ \div, class-name: "detail", "Space Limit"
          _ \div, class-name: "ui label",
            problem.permit.owner
            _ \div, class-name: \detail, \owner
          _ \div, class-name: "ui label",
            problem.permit.group
            _ \div, class-name: \detail, \group
        _ segment-box, desc: \description,
          _ \p, mathjax: true, problem.outlook?.desc
        _ \div, class-name: "ui two column grid",
          _ \div, class-name: \row,
            _ \div, class-name: \column,
              _ segment-box, desc: "input format",
                _ \p, null, problem.outlook?.in-fmt # mathjax here
            _ \div, class-name: \column,
              _ segment-box, desc: "output format",
                _ \p, null, problem.outlook?.out-fmt # mathjax here
          _ \div, class-name: \row,
            _ \div, class-name: \column,
              _ segment-box, desc: "sample input",
                _ \pre, null, problem.outlook?.sample-in
            _ \div, class-name: \column,
              _ segment-box, desc: "sample output",
                _ \pre, null, problem.outlook?.sample-out

      _ \div, class-name: "ui divider"

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
