require! {
  \react : {create-element}
  \co
  \debug
  \moment
}

window._ = create-element
# for key, value of R.DOM
#   window."_#key" = value
window.debug = debug
debug.enable "dollast:*"

log = debug \dollast:custom

$.fn.form.settings.rules.positive = (text) ->
  0 < parse-float text

$.fn.form.settings.rules.is-time = (text) ->
  # log {text}
  moment text, 'YYYY-MM-DD HH:mm:ss' .is-valid!

$.ajax-setup do
  content-type: 'application/json'

MathJax.Hub.Config do
  tex2jax:
    inline-math:
      * ['$','$']
      * ['\\(','\\)']
