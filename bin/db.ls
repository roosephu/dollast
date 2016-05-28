require! {
  \co
  \debug
  \./config
  \./models/solutions
  \./models/rounds
  \./models/problems
  \./models/users
  \./models/permit : {can-access}
}

log = debug \dollast:db

export solutions, rounds, problems, users
