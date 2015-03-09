filters = angular.module "dollast-filters", ["ngSanitize"]

filters.filter 'probRef', ->
  (prob) ->
    if prob?.outlook?.title
      "<a href='#/problem/#{prob._id}'>#{prob._id}. #{prob.outlook.title}</a>"
    else
      "hidden problem"
