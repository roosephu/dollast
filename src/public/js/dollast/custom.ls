require! {
  \react/addons : R
  \co
  \debug
}

window._ = R.create-element
for key, value of R.DOM
  window."_#key" = value
window.debug = debug
debug.enable "dollast:*"


$.fn.form.settings.rules.positive = (text) ->
  0 < parse-float text

$.ajax-setup do
  content-type: 'application/json'

MathJax.Hub.Config do
  tex2jax:
    inline-math:
      * ['$','$']
      * ['\\(','\\)']