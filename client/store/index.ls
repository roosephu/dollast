require! {
  \vue
  \vuex
  \./auth
}

state =
  session:
    guest: true
  error: void

mutations =
  login: (state, token) ->
    payload = auth.jwt.dec token
    client-info = JSON.parse payload.client
    local-storage.token = token
    vue.http.headers.common.Authorization = "Bearer #{token}"
    state.session =
      guest: false
      uid: client-info.uid
      token: token

  logout: (state) ->
    state.session = guest: true

  raise-error: (state, error) ->
    state.error = error

  resolve-error: ->
    state.error = void

module.exports = new vuex.Store do
  {state, mutations}
