require! {
  \vue
  \co
  \debug
  \../store
}

log = debug \dollast:actions

export login = ({dispatch}) ->
  if local-storage.token
    dispatch \login, local-storage.token

export logout = ({dispatch}) ->
  delete local-storage.token
  dispatch \logout

export raise-error = ({dispatch}, response, closable) ->
  log \raise, {response}
  error = response.errors[0]
  if closable
    error.closable = true
  dispatch \raiseError, error

export resolve-error = ({dispatch}) ->
  dispatch \resolveError
