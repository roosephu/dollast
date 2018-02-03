import { debug } from 'debug'
import axios from 'axios'

const log = debug('dollast:actions')

export async function waitFor ({ commit }, fn) {
  commit('waitFor', true)
  const ret = await fn
  commit('waitFor', false)
  return ret
}

export async function $fetch ({ commit, dispatch, state }, { method, url, data, progress, query, form }) {
  log('$fetch', { method, url, data, onUploadProgress: progress })
  const { data: response } = await dispatch('waitFor', axios({ method, url, data, onUploadProgress: progress }))
  log('response', { response, form })
  commit('checkResponseErrors', { response, form })

  if (state.error) {
    throw Error('run time error')
  }

  return response.data
}
