require! {
  \moment
  \vue
  \./code-link
  \./problem
  \./round
  \./user
}

vue.filter \problem, (problem) ->
  "#{problem._id}. #{problem.outlook.title}"

vue.filter \round, (round) ->
  "#{round._id}. #{round.title}"

vue.filter \user, (user) ->
  "#{user}"

vue.filter \time, (time) ->
  moment time .format "MMMM Do YYYY HH:mm:ss"

vue.filter \decimal, (value, fixed) ->
  Number value .to-fixed fixed

module.exports = {
  code-link
  problem
  round
  user
}
