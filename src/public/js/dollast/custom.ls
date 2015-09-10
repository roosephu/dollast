require! {
  \react/addons : R
  \co
}

window._ = R.create-element
for key, value of R.DOM
  window."_#key" = value

$.fn.form.settings.rules.positive = (text) ->
  0 < parse-float text
#
# $.ajax-setup do
#   content-type: 'application/json'
