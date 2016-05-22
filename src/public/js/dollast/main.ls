require! {
    \vue
    \vuex
    \vue-router
    \vue-resource
    \debug
    \moment
}

vue.config.debug = true
debug.enable "dollast:*"
vue.use vuex
vue.use vue-resource

log = debug \dollast:main

vue.use vue-router
require! \./router

app = require \./components/app.vue
  ..store = require \./store
app = vue.extend app

extra-rules =
  positive: (text) ->
    0 < parse-float text
  is-time: (text) ->
    # log {text}
    moment text, 'YYYY-MM-DD HH:mm:ss' .is-valid!
  is-password: (text) ->
    log {text}
    4 <= text.length and text.length <= 15

  is-user-id: (text) ->
    # log {text}
    if 4 > text.length or text.length > 15
      false
    else
      /^[a-zA-Z0-9._]*$/.test text

  is-access: (text) ->
    /^[0-7]{3}$/.test text

for key, val of extra-rules
  # log key
  $.fn.form.settings.rules[key] = val

router.start app, '#app'

if MathJax
  MathJax.Hub.Config do
    tex2jax:
      inline-math:
        * ['$','$']
        * ['\\(','\\)']
else
  log.error 'No MathJax found.'
