require! {
  \debug
  \axios
}

log = debug \dollast:actions

export wait-for = ({commit}, fn) ->>
  commit \waitFor, true
  ret = await fn
  commit \waitFor, false
  ret

export $fetch = ({commit, dispatch, state}, {method, url, data, progress, query, form}) ->>
  log {method, url, data, onUploadProgress: progress}
  {data: response} = await dispatch \waitFor, axios {method, url, data, onUploadProgress: progress}
  commit \checkResponseErrors, {response, form}
  if state.error
    ...
  response.data
