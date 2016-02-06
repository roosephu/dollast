require! {
  \co
  \redux-actions : {create-action}
  \../utils/auth
  \../utils/request
  #\superagent : request
  \../components/utils : {to-server-fmt}
}

log = debug 'dollast:action'

set-jwt = (token) ->
  request.set-headers Authorization: "Bearer #{token}"
  #old-settings = $.ajax-setup!
  #$.ajax-setup old-settings <<<<
    #headers:
      #Authorization: "Bearer #{token}"

export on-load-from-token = create-action 'load-from-token', (token) ->
  if token
    try
      payload = auth.jwt.dec token
      client-info = JSON.parse payload.client
      set-jwt token
      token
    catch
      new Error "invalid token: #{token}. error message: #{e.message}"
  else
    new Error "no given token"

export fetch = (endpoint) ->
  co.wrap (dispatch) ->*
    dispatch do
      type: \loading
      payload: endpoint + "/get"
    data = yield request \get, endpoint .end!
    dispatch do
      type: \fetch
      payload: {endpoint, data.body}
    # dispatch do
    #   type: \loading
    #   payload:
    #     endpoint: endpoint
    #     loading: \done

export send = (endpoint, info) ->
  co.wrap (dispatch) ->*
    dispatch do
      type: \loading
      payload: endpoint + "/post"
    data = yield request \post, endpoint .send info .end!
    dispatch do
      type: \send
      payload: {endpoint, data.body}
    # dispatch do
    #   type: \loading
    #   payload:
    #     endpoint: endpoint
    #     loading: \done

export on-login = (info) ->
  co.wrap (dispatch, get-state) ->*
    thunk = send \/site/login, info
    yield thunk dispatch
    token = get-state!.get-in [\db, \site, \login, \post, \payload, \token]
    dispatch on-load-from-token token

export on-set-ui = (endpoint, data) ->
  return
    type: \ui
    payload: {endpoint, data}

export on-register = (info) ->
  return send \/user/register, info

export on-logout = create-action 'logout', ->
  delete local-storage.token
  set-jwt ""
  null

export on-update-problem = (pid, info) ->
  info |>= to-server-fmt
  log 'update problem', info
  return send "/problem/#{pid}", info

export on-refresh-problem-list = ->
  return fetch \/problem

export on-get-problem = (pid) ->
  return fetch "/problem/#{pid}"

export on-submit-solution = (data) ->
  return send \/solution/submit, data

export on-get-solutions-list = ->
  return fetch \/solution

export on-get-solution = (sid) ->
  return fetch "/solution/#{sid}"

export on-get-round = (rid) ->
  return fetch "/round/#{rid}"

export on-upload-files = co.wrap (pid, files) ->*
  log {files}
  req = request \post, "/data/#{pid}/upload"
  for f in files
    req.attach f.name, f
  data = yield req.end!

  return
    type: \problem/upload
    payload: [f.name for f in files]

export on-add-prob-to-round = (pid) ->
  return fetch "/problem/#{pid}/brief"

export on-round-modify = (rnd) ->
  return send "/round/#{rnd.rid}", rnd

export on-get-rounds-list = ->
  return fetch \/round

export on-get-round-board = (rid) ->
  return fetch "/round/#{rid}/board"

export on-update-user = (uid, updated) ->
  return send "/user/#{uid}", updated

export on-repair-problem = (pid) ->
  return fetch "/problem/#{pid}/repair"

export on-get-problem-stat = (pid) ->
  return fetch "/problem/#{pid}/stat"

export on-get-user-profile = (uid) ->
  return fetch "/user/#{uid}"
