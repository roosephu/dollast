import Vue from 'vue'
import auth from './auth'
import { debug } from 'debug'
import Cookies from 'js-cookie'
/* global localStorage */

const log = debug('dollast:store:mutations')

export function resolveError (state) {
  Vue.set(state, 'error', null)
}

// export function login (state, token) {
//   if (token == null) {
//     token = localStorage.token
//   }
//   if (token == null) {
//     return
//   }
//   const payload = auth.jwt.dec(token)
//   const clientInfo = JSON.parse(payload.client)
//   localStorage.token = token
//   Vue.set(state, 'session', {
//     guest: false,
//     user: clientInfo.user,
//     token: token
//   })
// }

export function login (state) {
  const session = Cookies.get('session')
  if (session) {
    const { user } = JSON.parse(window.atob(session))
    Vue.set(state, 'session', {
      user,
      guest: false
    })
  } else {
    Vue.set(state, 'session', {
      guest: true
    })
  }
}

export function logout (state) {
  Cookies.remove('session')
  Vue.set(state, 'session', {
    guest: true
  })
}

export function waitFor (state, progress) {
  Vue.set(state, 'isLoading', progress)
}

export function raiseError (state, {response, closable}) {

}

export function checkResponseErrors (state, {response, $form}) {

}
