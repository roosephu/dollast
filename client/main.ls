require! {
  \vue
  \vuex
  \vue-router
  \vue-resource
  \debug
  \./validation
}

vue.use vuex
vue.config.debug = true
debug.enable "dollast:*"

log = debug \dollast:main

vue.use vue-router
require! \./router
vue.use vue-resource
vue.http.options.root = if process.env.NODE_ENV == \development then \/monk/query else \/api

app = require \./components/app.vue
  ..store = require \./store
app = vue.extend app

router.start app, '#app'

if MathJax
  MathJax.Hub.Config do
    tex2jax:
      inline-math:
        * ['$','$']
        * ['\\(','\\)']
else
  log.error 'No MathJax found.'

if module.hot
  module.hot.accept!
