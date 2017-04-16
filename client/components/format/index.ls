require! {
  \moment
  \vue : {default: vue}
  \./code-link
  \./problem
  \./pack
  \./user
}

vue.filter \problem, (problem) ->
  "#{problem._id}. #{problem.outlook.title}"

vue.filter \pack, (pack) ->
  "#{pack._id}. #{pack.title}"

vue.filter \user, (user) ->
  "#{user}"

vue.filter \time, (time) ->
  moment time .format "YYYY MMM Do HH:mm:ss"

vue.filter \decimal, (value, fixed) ->
  if \number != typeof value
    ''
  else
    Number value .to-fixed fixed

vue.filter \concise-time, (time) ->
  moment time .format "YYYY-MM-DD HH:mm:ss"

module.exports = {
  code-link
  problem
  pack
  user
}
