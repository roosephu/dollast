require! {
  \./code-link
  \./problem
  \./round
  \./user
}

module.exports = {
  code-link
  problem
  round
  user

  formatter:
    problem: (prob) ->
      "#{prob._id}. #{prob.outlook.title}"

    round: (rnd) ->
      "#{rnd._id}. #{rnd.title}"

    user: (user) ->
      "#{user}"

}
