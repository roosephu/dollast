filters = angular.module "dollast-filters", ["ngSanitize"]

filters.filter 'probRef', ->
  (prob) ->
    if prob?.outlook?.title
      "<a href='#/problem/#{prob._id}'>#{prob._id}. #{prob.outlook.title}</a>"
    else
      "hidden problem"

filters.filter 'rndRef', ->
  (rnd) ->
    if "number" == typeof rnd
      rnd
    else if "object" == typeof rnd
      "#{rnd._id}. #{rnd.title}"
