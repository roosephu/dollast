import Vue from 'vue'
import Vuex from 'vuex'
import * as mutations from './mutations'
import * as actions from './actions'
import { debug } from 'debug'

const log = debug('dollast:store')

let state = {
  session: {
    guest: true
  },
  error: null,
  isLoading: false
}

const getters = {
  user (state) {
    return state.session.user
  },

  isLoading (state) {
    return state.isLoading
  },

  error (state) {
    return state.error
  }
}

Vue.use(Vuex)

export default new Vuex.Store({
  state,
  mutations,
  getters,
  actions
})
