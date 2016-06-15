require! {
  \react : {create-class}
  \react-redux : {connect}
  \immutable : I
  \../elements : {statistics, icon-text}
  \../format : {prob-link}
  \../../actions : {on-get-problem-stat}
  \prelude-ls : {sort-with, average, map, filter}
}

log = debug \dollast:component:problem:stat

selector = (state, props) ->
  pid = props.params.pid
  sols: state.get-in [\db, \problem, pid, \stat, \get, \sols], I.from-JS do
    []
  prob: state.get-in [\db, \problem, pid, \stat, \get, \prob], I.from-JS do
    _id: 0

generate-stat = (sols) ->
  if sols.length == 0
    return
      solved: 0
      mean: 0
      median: 0
      stddev: 0
  scores = for sol in sols
    sol.doc.final.score || 0

  mean = average scores
  median = scores[Math.floor scores.length / 2]
  variance = (average map (-> it * it), scores) - mean * mean
  stddev = Math.sqrt variance
  solved = scores |> filter (== 1) |> (.length)

  return {solved, mean, median, stddev}

module.exports = (connect selector) create-class do
  display-name: \prob-stat

  component-did-mount: ->
    @props.dispatch on-get-problem-stat @props.params.pid

  render: ->
    pid = @props.params.pid
    sols = @props.sols.to-JS!
    stat = generate-stat sols

    _ \div, null,
      _ \h1, class-name: "ui header dividing", "Statistics for Problem #{pid}"
      _ prob-link, prob: @props.prob.to-JS!

      _ \h3, class-name: "ui header dividing", "numbers"
      _ statistics,
        stat:
          "accepted users": stat.solved
          # "accepted programs": "???"
          mean: stat.mean
          median: stat.median
          "standard deviation": stat.stddev
