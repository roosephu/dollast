require! {
  \vue
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
  {data: response} = await dispatch \waitFor, axios {method, url, data, progress, query}
  commit \checkResponseErrors, {response, form}
  if state.error
    ...
  response.data
