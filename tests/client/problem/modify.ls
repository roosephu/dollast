require! {
  \node-fetch : fetch
  \co
}

module.exports =
  'check priviledge when creating': (client) ->
    client
      ..end!

  'create problem correctly': (client) ->
    client
      ..url \http://localhost:3000/#!/problem/create
      ..execute ->
        window.localStorage.token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzZXJ2ZXIiOiJ7XCJfaWRcIjpcInJvb3NlcGh1XCIsXCJncm91cHNcIjp7XCJ1c2Vyc1wiOnRydWV9fSIsImNsaWVudCI6IntcInVpZFwiOlwicm9vc2VwaHVcIn0iLCJpYXQiOjE0NjgxNDIyOTAsImV4cCI6MTQ2ODIyODY5MH0.BViCJ_iKwhYehEcecA1mI0TO4rhsMW-2HX6rnEuB4iI'
      ..refresh!
      ..pause 100

      ..set-value 'input[name=title]', 'A + B problem'
      ..set-value 'input[name=timeLimit]', 1
      ..set-value 'input[name=spaceLimit]', 512
      ..click '#judger'
      ..expect .element '#judger .menu :nth-child(1)' .to .have .text .equals 'string'
      ..click '#judger .menu :nth-child(1)'
      ..set-value 'input[name=stackLimit]', 4
      ..set-value 'input[name=outputLimit]', 10
      ..set-value 'textarea[name=description]', '<b>Given</b> two integers $A$ and $B$, your task is to compute $A+B$.'
      ..set-value 'textarea[name=inputFormat]', 'One line for $A, B$'
      ..set-value 'textarea[name=outputFormat]', 'One line for $A + B$'
      ..set-value 'textarea[name=sampleInput]', '1 2'
      ..set-value 'textarea[name=sampleOutput]', '3'

      ..expect .element 'input[name=owner]' .to .have .value .equals 'roosephu'
      ..expect .element 'input[name=group]' .to .have .value .equals 'problems'
      ..expect .element 'input[name=access]' .to .have .value .equals 'rwxrw-r--'

      ..end!