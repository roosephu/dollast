require! {
  'koa'
  'koa-json'
  'koa-static'
  'koa-bodyparser'
  'koa-generic-session'
  'koa-passport'
  'util'
  'koa-validate'
  'koa-router'
  'log4js'
  'koa-send'
  'path'
}

app = koa!

# ==== Database ====

logger = log4js.get-logger 'dollast'
global.runner = require './runner'
require! "./db"

logger.fatal "No Database found" if !db

# ==== Logger ====
app.use (next) ->*
  console.log "#{@req.method} #{@req.url}"
  yield next

# ==== Passport ====

app.keys = ['drdrd']
app.use koa-generic-session do
  cookie:
    max-age: 1000 * 60 * 5
app.use koa-bodyparser!

require './auth' .init db

app.use koa-passport.initialize!
app.use koa-passport.session!

# ==== JSON and Static Serving ====

app.use (next) ->*
  @session.theme ||= "default"
  yield next

app.use koa-json!
app.use koa-static "public/"
app.use (next) ->*
  if @method in ['HEAD', 'GET']
    return if yield koa-send @, @path, index: 'index.html', root: path.resolve "theme/#{@session.theme}"
  yield next

# ========= Router ===============

public-router = new koa-router!

public-router
  .post '/login', (next) ->*
    cb = (err, user, info) ~>*
      throw that if err
      if user != false
        yield @login user
        @body = status: true
      else
        @body = status: false
    yield koa-passport.authenticate 'local', cb .call @, next
  .get '/logout', (next) ->*
    @logout!
    @redirect '/#/'

app.use public-router.middleware!

# require authenticated
app.use (next) ->*
  if true or @req.is-authenticated!
    # console.log "#{util.inspect(@session)}"
    yield next
  else
    @redirect '/login' # should be login

# now begin our private router

private-router = new koa-router!

private-router
  .get '/problem', ->*
    @body = probs: yield db.prob.list!
  .get '/problem/next-count', ->*
    @body = _id: yield db.prob.next-count!
  .get '/problem/:pid', ->*
    pid = @params.pid
    @body = prob: yield db.prob.show pid, mode: "view"
  .get '/problem/:pid/total', ->*
    pid = parse-int @params.pid
    @body = prob: yield db.prob.show pid, mode: "total"
  .put '/problem/:pid', ->*
    @body = status: yield db.prob.modify @params.pid, @request.body
  .delete '/problem/:pid', ->*
    ...
  .post '/submit', ->*
    uid ?= @session.passport.user?._id
    uid ?= "roosephu"
    console.log "uid: #{uid}"
    @body = status: yield db.sol.submit @request.body, uid
  .get '/solution', ->*
    @body = sols: yield db.sol.list!
  .get '/session', ->*
    @body = uid: if @session.passport?.user?._id? then that else void
  .get '/solution/:sid', ->*
    @body = sol: yield db.sol.show parse-int @params.sid
  .get '/round', ->*
    @body = rounds: yield db.rnd.list!
  .get '/round/next-count', ->*
    @body = _id: yield db.rnd.next-count!
  .get '/round/:rid', ->*
    rid = parse-int @params.rid
    @body = yield db.rnd.show rid, mode: "view"
  .put '/round/:rid', ->*
    rid = parse-int @params.rid
    @body = status: yield db.rnd.modify rid, @request.body
  .get '/round/:rid/total', ->*
    rid = parse-int @params.rid
    @body = yield db.rnd.show rid, mode: "total"
  .delete '/round/:rid', ->*
    @body = status: yield db.rnd.delete @params.rid
  .get '/theme/:theme', ->*
    @session.theme = @params.theme
    @body = status: true

app.use private-router.middleware!

# ====================================

console.log "Listening port 3000"
app.listen 3000
