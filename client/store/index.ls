require! {
  \vue
  \vuex
  \./actions
  \./mutations
}

state =
  session:
    guest: true
  error: void
  is-loading: false

getters =
  user: (.session.user)
  is-loading: (.is-loading)
  error: (.error)

vue.use vuex
module.exports = new vuex.Store do
  {state, mutations, getters, actions}
