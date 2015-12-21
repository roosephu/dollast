require! {
  reflux
}

export actions = reflux.create-actions [
  * \addEvent
]

export stores = reflux.create-store do
  listenables: actions
  get-initial-state: ->
    events: []
  on-add-event: (evt) ->
    @state.events += [evt]
