require! {
  "supertest"
  "mocha"
  "../bin/server": app
}

_it = it

request = supertest.agent app.listen!

describe "hello world", ->
  describe "when GET /", ->
    _it "should ..?", (done) ->
      request
        .get '/'
        .expect /script/, done
