require! {
  \redux : {combine-reducers}
  \redux-actions : {handle-actions}
  # \redux-simple-router : {UPDATE_PATH}
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

reducer =
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

    \problem/update : use-default-throw (state, action) ->
      state.set-in [\problem, \update], I.from-JS action.payload

    \round/add-prob : use-default-throw (state, action) ->
      state.update-in [\round, \update, \probs], (probs = I.List!) ->
        probs.push action.payload

    \problem/repair : use-default-throw (state, action) ->
      state.set-in [\problem, \update, \config, \dataset], I.from-JS action.payload.payload

    \fetch : use-default-throw (state, action) ->
      {endpoint, body} = action.payload
      endpoint = "db" + endpoint + "/get"
      path = endpoint.split '/'
      state.set-in path, I.from-JS body

    \send : use-default-throw (state, action) ->
      {endpoint, body} = action.payload
      state

    init-state
#
# route-initial-state = I.from-JS do
#   url:
#     changeId: 1
#     path: undefined
#     state: undefined
#     replace: false
#
# route-reducer = (state=route-initial-state, action) ->
#   if action.type == UPDATE_PATH
#     state.set \url,
#       path: payload.path,
#       change-id: state.change-id + (payload.avoid-router-update ? 0 : 1),
#       replace: payload.replace
#       state: payload.state,
#   return state

# export root-reducer = combine-reducers Object.assign {}, reducer, routing: route-reducer
export root-reducer = reducer
