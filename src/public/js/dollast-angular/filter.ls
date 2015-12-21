filters = angular.module "dollast-filters", ["ngSanitize"]

filters.filter 'probRef', ->
  (prob) ->
    if prob?.outlook?.title
      "<a href='#/problem/#{prob._ \i,d}'>#{prob._ \i,d}. #{prob.outlook.title}</a>"
    else
      "hidden problem"

filters.filter 'rndRef', ->
  (rnd) ->
    if "number" == typeof rnd
      rnd
    else if "object" == typeof rnd
      "#{rnd._ \i,d}. #{rnd.title}"
