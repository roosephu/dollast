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
app.use koa-generic-session(
  cookie:
    max-age: 1000 * 60 * 5
)
app.use koa-bodyparser!

require './auth' .init db

app.use koa-passport.initialize!
app.use koa-passport.session!

# ==== JSON and Static Serving ====

app.use koa-json!
app.use koa-static "public/"

# ========= Router ===============

public-router = new koa-router!

public-router
  .post '/login',
    koa-passport.authenticate 'local',
      success-redirect: '#/'
      failure-redirect: '/#/login'
  .get '/logout', (next) ->*
    @logout!
    @redirect '/#/'

app.use public-router.middleware!

# require authenticated
/* app.use (next) ->*
  if @req.is-authenticated!
    console.log "#{util.inspect(@session)}"
    yield next
  else
    @redirect '/login' # should be login
*/

# now begin our private router

private-router = new koa-router!

private-router
  .get '/problem', ->*
    @body = yield db.prob.list!
  .get '/problem/:pid', ->*
    @body = yield db.prob.show @params.pid
  .post '/solution/submit', ->*
    console.log "#{util.inspect @session}"
    logger.trace 'submit session'
    uid ?= @session.passport.user?._id?
    uid ?= "roosephu"
    @body = yield db.sol.submit @request.body, uid
  .get '/solution', ->*
    @body = yield db.sol.list!
  .get '/session', ->*
    console.log "Current session: #{util.inspect @session}"
    @body =
      user: if @session.passport?.user?._id? then that else void
  .get '/solution/:sid', ->*
    @body = yield db.sol.show @params.sid

app.use private-router.middleware!

# ====================================

console.log "Listening port 3000"
app.listen 3000
