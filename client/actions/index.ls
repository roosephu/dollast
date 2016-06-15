require! {
  \vue
  \co
  \debug
  \../store
}

log = debug \dollast:actions

export login = co.wrap ({dispatch}, info) ->*
  {data} = yield vue.http.post \/site/login, info
  local-storage.token = data.payload.token
  dispatch \loadFromToken, data.payload.token

export load-from-token = ({dispatch}) ->
  if local-storage.token
    dispatch \loadFromToken, local-storage.token

export logout = ({dispatch}) ->
  delete local-storage.token
  dispatch \logout

export raise-error = ({dispatch}, response) ->
  log \raise, {response}
  dispatch \raiseError, response.errors[0]

export resolve-error = ({dispatch}) ->
  dispatch \resolveError
