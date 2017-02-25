require! {
  \vue
  \vuex
  \vue-router
  \axios
  \debug
  \./validation
  \./components/app
}

debug.enable "dollast:*"
log = debug \dollast:main

axios.defaults.base-URL = if process.env.NODE_ENV == \mock then \/monk/query else \/api

new vue do
  el: '#app'
  router: require \./router
  store: require \./store
  render: (h) -> h app

# router.start app, '#app'

if MathJax?
  MathJax.Hub.Config do
    tex2jax:
      inline-math:
        * ['$','$']
        * ['\\(','\\)']
else
  log 'No MathJax found.'

if module.hot
  module.hot.accept!
