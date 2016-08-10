require! {
  \node-fetch : fetch
  \co
}

module.exports =
  # before: (client) ->

  'decode token': (client) ->
    client
      ..url 'http://localhost:3000/'
      ..execute ->
        window.localStorage.token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzZXJ2ZXIiOiJ7XCJfaWRcIjpcInJvb3NlcGh1XCIsXCJncm91cHNcIjp7XCJ1c2Vyc1wiOnRydWV9fSIsImNsaWVudCI6IntcInVpZFwiOlwicm9vc2VwaHVcIn0iLCJpYXQiOjE0NjgxNDIyOTAsImV4cCI6MTQ2ODIyODY5MH0.BViCJ_iKwhYehEcecA1mI0TO4rhsMW-2HX6rnEuB4iI'
      ..refresh!
      ..pause 100
      ..expect .element '.right.menu > .labeled' .text .equals 'roosephu'
      ..end!