require! {
  \redux : {combine-reducers}
  \redux-actions : {handle-actions}
  \immutable : I
  \../utils/auth
  \../actions : A
}

log = debug 'dollast:reducers'

export init-state = I.from-JS do
  session:
    guest: true

load-from-token-reducer = (state, action) ->
  #log 'lftr', {state, action}
  token = action.payload

  payload = auth.jwt.dec token
  local-storage.token = token
  client-info = JSON.parse payload.client

  state.set \session, I.from-JS do
    guest: false
    token: token
    uid: client-info.uid

default-throw = (state, action) ->
  log 'error found:', action.payload.message, 'with', {state, action}
  state

use-default-throw = (next) ->
  next: next
  throw: default-throw

export root-reducer =
  handle-actions do
    \load-from-token : load-from-token-reducer

    \register : use-default-throw (state, action) ->
      log \register, {action}
      state

    \login : use-default-throw (state, action) ->
      log {state, action}
      if action.error
        state
      else
        load-from-token-reducer state, payload: action.payload.token

    \error : use-default-throw (state, action) ->
      state

    \logout : use-default-throw (state, action) ->
      state.set \session, I.from-JS guest: true

    \problem/refresh-list : use-default-throw (state, action) ->
      state.set-in [\problem, \list], I.from-JS action.payload

    \problem/get : use-default-throw (state, action) ->
      state.set-in [\problem, action.payload.load], I.from-JS action.payload

    \problem/update : use-default-throw (state, action) ->
      state.set-in [\problem, \update], I.from-JS action.payload

    \solution/list : use-default-throw (state, action) ->
      state.set-in [\solution, \list], I.from-JS action.payload

    \solution/get : use-default-throw (state, action) ->
      state.set-in [\solution, \show] I.from-JS action.payload

    \round/get : use-default-throw (state, action) ->
      state.set-in [\round, action.payload.load], I.from-JS action.payload

    \round/add-prob : use-default-throw (state, action) ->
      state.update-in [\round, \update, \probs], (probs = I.List!) ->
        probs.push action.payload

    \round/list : use-default-throw (state, action) ->
      state.set-in [\round, \list], I.from-JS action.payload

    \round/board : use-default-throw (state, action) ->
      state.set-in [\round, \board], I.from-JS action.payload

    init-state
