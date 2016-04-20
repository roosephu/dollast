require! {
    \vue
    \vuex
    \vue-router
    \vue-resource
    \debug
}

vue.use vuex
vue.use vue-resource
vue.config.debug = true
debug.enable "dollast:*"

vue.use vue-router
require! \./router

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
