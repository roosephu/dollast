require! {
  \redux: {reduce-reducers}
}

export class actions-creator
  (@default-throw) ->
    
  create-action: (type, func) ->
    (...args) ->
      try
        payload = func ...args
        action = {type, payload}
        if payload instanceof Error
          action.error = true
      catch e
        throw e
        #action = 
          #type: 'internal-error'
          #payload: e
          #error: true
      action
  
  handle-action: (type, map) ->
    if \function == typeof map
      map = next: map
    if map.throw is null
      map.throw = @default-throw

    (state, action) ->
      if action.type != type
        return state

      if action.error
        reducer = map.throw
      else
        reducer = map.next

      try
        state = reducer state, action
      catch e
        throw e

      state

  handle-actions: (handler-map, init-state = null) ->
    reducers = for type, reducer in handler-map
      handle-action type, reducer
    root = reduce-reducers ...reducers
    (state = init-state, action) ->
       root state, action
