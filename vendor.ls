require! {
  \child_process : {exec}
  \debug
  \moment
}

vendors = [
  \react, 
  \redux,
  \redux-actions, 
  \react-redux, 
  \immutable, 
  \co, 
  \debug, 
  \superagent, 
  \superagent-promise, 
  \bluebird, 
  \react-highlight, 
  \react-router, 
  \redux-devtools/lib/react,
  \react-dropzone,
  \prelude-ls,
  \redux-promise,
  \redux-logger,
  \redux-devtools,
  \redux-thunk,
]

mk_ven = "browserify "
mk_ \a,pp = "browserify -v "

for x in vendors
  mk_ven += " -r " + x
  mk_ \a,pp += " -x " + x

mk_ven += " > public/js/vendors.js"
mk_ \a,pp += " public/js/dollast/app.js -o public/js/app.js"

console.log mk_ven
exec mk_ven, ->
  log "vendors successful"
console.log mk_ \a,pp

log = debug \vendors

callback = ->
  exec mk_ \a,pp, ->
    log moment!.format!
    set-timeout callback, 10000
#set-interval callback, 3000
callback!