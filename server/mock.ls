require! {
  \koa
  \koa-joi-router
  \co
  \debug
}

log = debug \dollast:monk

app = new koa!

class Database
  ->
    @db = {}

  add: (content) ->
    @db <<<< content

  reset: ->
    @db = {}

  query: (path) ->
    @db[path]

db = new Database!

add = ->*
  log \add, @request.body
  db.add @request.body
  @body = done: true

reset = ->*
  log \reset
  db.reset!
  @body = done: true

query = ->*
  {path} = @params
  log \query, path, db.query path
  @body = db.query path

dump = ->*
  @body = db.db
  log \dump, db.db

router = new koa-joi-router!
router
  .post '/add',        add
  .get '/reset',       reset
  .get '/dump',        dump
  .get '/query/:path', query

app.use router.middleware!

module.exports = app