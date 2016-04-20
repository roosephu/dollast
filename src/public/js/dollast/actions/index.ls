require! {
  \vue
  \../store
  \co
  \debug
}

log = debug \dollast:actions

export login = co.wrap ({dispatch}, info) ->*
  {data} = yield vue.http.post \/site/login, info
  dispatch \loadFromToken, data.payload.token

export logout = ({dispatch}) ->
  dispatch \logout
