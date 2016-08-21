require! {
  \vue
  \vuex
  \debug
  \moment
  \./auth
}

log = debug \dollast:store

state =
  session:
    guest: true
  error: void

mutations =
  login: (state, token) ->
    {payload, header} = auth.decode token
    if header.iss == \dollast and moment! <= header.exp
      local-storage.token = token
      vue.http.headers.common.Authorization = "Bearer #{token}"
      state.session =
        guest: false
        user: payload._id
        token: token

  logout: (state) ->
    delete local-storage.token
    vue.http.headers.common.Authorization = ""
    state.session = guest: true

  raise-error: (state, error) ->
    state.error = error

  resolve-error: ->
    state.error = void

module.exports = new vuex.Store do
  {state, mutations}
