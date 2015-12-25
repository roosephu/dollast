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

extra-rules =
  positive: (text) ->
    0 < parse-float text
  is-time: (text) ->
    # log {text}
    moment text, 'YYYY-MM-DD HH:mm:ss' .is-valid!
  is-password: (text) ->
    4 <= text.length and text.length <= 15

for key, val of extra-rules
  # log key
  $.fn.form.settings.rules[key] = val

# log $.fn.form.settings.prompt
# $.fn.form.settings.prompt.is-password = 'A valid password must contains 4 to 15 characters'

$.ajax-setup do
  content-type: 'application/json'

if MathJax
  MathJax.Hub.Config do
    tex2jax:
      inline-math:
        * ['$','$']
        * ['\\(','\\)']
else
  log.error 'No MathJax found.'
