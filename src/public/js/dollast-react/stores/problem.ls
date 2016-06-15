require! {
  \reflux
  \co
  \../components/utils : U
}

export actions = reflux.create-actions [
  * \read
  * \update
  * \delete
  * \nextCount
]

store = reflux.create-store do
  listenables: actions

  on-read: ->

  on-update: (all-values) ->
    console.log all-values
    co ->*
      $

  on-delete: ->

  on-next-count: co.wrap ->*
    $.get "/problem/next-count"
