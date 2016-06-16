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

export raise-error = ({dispatch}, response) ->
  log \raise, {response}
  dispatch \raiseError, response.errors[0]

export resolve-error = ({dispatch}) ->
  dispatch \resolveError
