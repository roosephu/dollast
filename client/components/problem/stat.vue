<template lang="jade">
view
  .menu(slot="config")
    .ui.header links
    a.item(href="#!/problem/{{problem._id}}") 
      i.icon.browser
      | Go to Problem
    a.item(v-link="{name: 'submissions', query: {problem: problem._id}}") 
      i.icon
      | All submissions

  .ui.basic.segment(:class="{loading: $loadingRouteData}", slot="main")
    h1.ui.header.dividing Statistics for Problem {{problem._id}}
    // problem(:prob="problem")

    h3.ui.header.dividing numbers
    .ui.statistics
      .statistic(v-for="(key, val) in stat")
        .value {{val}}
        .label {{key}}
</template>

<script>
require! {
  \vue
  \debug
  \co
  \prelude-ls : {average, map, filter}
  \../view
  \../format
  \../../actions : {check-response-errors}
}

log = debug \dollast:component:problem:stat

generate-stat = (sols) ->
  if sols.length == 0
    return
      solved: 0
      mean: 0
      median: 0
      stddev: 0
  scores = for sol in sols
    sol.doc.summary.score || 0

  mean = average scores
  median = scores[Math.floor scores.length / 2]
  variance = (average map (-> it * it), scores) - mean * mean
  stddev = Math.sqrt variance
  solved = scores |> filter (== 1) |> (.length)

  return {solved, mean, median, stddev}

module.exports =
  vuex:
    actions:
      {check-response-errors}

  data: ->
    stat: []
    problem: {}

  route:
    data: co.wrap (to: params: {problem}) ->*
      {data: response} = yield vue.http.get "problem/#{problem}/stat"
      if @check-response-errors response
        return null
      {submissions, problem} = response.data

      stat = generate-stat submissions
      stat:
        "accepted users": stat.solved
        # "accepted programs": "???"
        mean: stat.mean
        median: stat.median
        "standard deviation": stat.stddev
      problem: problem

  components:
    {view} <<< format{problem}

</script>
