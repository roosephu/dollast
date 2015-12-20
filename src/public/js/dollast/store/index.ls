require! {
  \redux : {create-store, apply-middleware, compose}
  \redux-promise : promise-middleware
  \redux-thunk
  \redux-logger : create-logger
  \../reducers : {root-reducer}
  \redux-devtools : {dev-tools, persist-state}
  \immutable : I
} 

log = debug 'dollast:store'

error-middleware = (store) -> 
  dispatch = store.dispatch
  get-state = store.get-state

  (next) -> 
    (action) ->
      if action instanceof Function
        add-jwt = (request) ->
          token = get-state!.get-in [\session, \token], null
          if token
            request .= set \Authorization, "Bearer #{token}"

        action add-jwt, dispatch, get-state
        return

      payload = action.payload
      if payload instanceof Error
        action.error = true
        
      if payload?.constructor?.name == \Response
        #log action.payload.constructor.name, action.payload
        action.payload .= body

      try
        next action
      catch
        log e

export configure-store = (init-state) ->
  #promise-middleware = redux-promise.promise-middleware
  #log {root-reducer, create-logger, promise-middleware}
  logger = create-logger do
    transformer: (state) ->
      #log 'transformer', state
      I.from-JS state .to-JS!
  final-create-store = compose do
    apply-middleware error-middleware, promise-middleware, logger
    dev-tools!
    persist-state window.location.href.match /[?&]debug_session=([^&]+)\b/
  store = (final-create-store create-store) root-reducer, init-state
