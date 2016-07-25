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

add = (ctx) ->
  log \add, ctx.request.body
  db.add ctx.request.body
  ctx.body = done: true

reset = (ctx) ->
  log \reset
  db.reset!
  ctx.body = done: true

query = (ctx) ->
  {path} = ctx.params
  log \query, path, db.query path
  ctx.body = db.query path

dump = (ctx) ->
  ctx.body = db.db
  log \dump, db.db

router = new koa-joi-router!
router
  .post '/add',        add
  .get '/reset',       reset
  .get '/dump',        dump
  .get '/query/:path', query

app.use router.middleware!

module.exports = app