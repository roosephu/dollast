require! {
  \vue
  \vuex
  \./auth
}

state =
  session:
    guest: true

mutations =
  load-from-token: (state, token) ->
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

module.exports = new vuex.Store do
  {state, mutations}
