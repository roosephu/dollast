require! {
  \node-fetch : fetch
  \co
}

module.exports =
  before: co.wrap (client, done) ->*
    yield fetch "http://localhost:3000/monk/reset"
    yield fetch "http://localhost:3000/monk/add",
      method: \POST
      body: JSON.stringify do
        problem:
          data:
            * _id: \1
              outlook:
                title: "A+B problem"
            * _id: \2
              outlook:
                title: "two"
      headers:
        'Content-Type': "application/x-javascript"
    done!

  'fetch data correctly': co.wrap (client) ->*
    client
      ..url "http://localhost:3000/#!/problem"
      ..pause 1000
      ..expect .element '#problems > :nth-child(1) .label'
        .text .equals "1. A+B problem"
      ..expect .element '#problems > :nth-child(1) .label'
        .to .have .attribute \href .equals \http://localhost:3000/#/problem/1

      ..expect .element '#problems > :nth-child(2) .label'
        .text .equals "2. two"
      ..expect .element '#problems > :nth-child(2) .label'
        .to .have .attribute \href .equals \http://localhost:3000/#/problem/2

      ..end!
