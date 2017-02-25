<template lang="jade">
window
  .menu(slot="config")
    .ui.header links
    a.item(:href="'#!/problem/' + problem._id")
      i.icon.browser
      | Go to Problem
    router-link.item(go="{name: 'submissions', query: {problem: problem._id}}")
      i.icon
      | All submissions

  .ui.basic.segment(:class="{loading: isLoading}", slot="main")
    h1.ui.header.dividing Statistics for Problem {{problem._id}}
    // problem(:prob="problem")

    h3.ui.header.dividing numbers
    .ui.statistics
      .statistic(v-for="(val, key) in stat")
        .value {{val}}
        .label {{key}}
</template>

<script>
require! {
  \vue
  \vuex : {map-actions, map-getters}
  \debug
  \prelude-ls : {average, map, filter}
  \../window
  \../format
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

  data: ->
    stat: []
    problem: {}

  watch:
    $route: ->
      @fetch!

  computed: map-getters [\isLoading]

  methods: (map-actions [\$fetch]) <<<
    fetch: ->>
      {submissions, problem} = await @$fetch method: \GET, url: "problem/#{@$route.params.problem}/stat"
      stat = generate-stat submissions

      @ <<<
        stat:
          "accepted users": stat.solved
          # "accepted programs": "???"
          mean: stat.mean
          median: stat.median
          "standard deviation": stat.stddev
        problem: problem

  components:
    {window} <<< format{problem}

</script>
