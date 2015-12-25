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

export on-login = co.wrap (info) ->*
  log "store received", info
  ret = yield request \post, \/site/login .send info .end!
  on-load-from-token ret.body.token

export on-register = co.wrap (info) ->*
  data = yield request \post, \/user/register .send info .end!

  return
    type: \register
    payload: data.body

export on-logout = create-action 'logout', ->
  delete local-storage.token
  set-jwt ""
  null

export on-update-problem = co.wrap (pid, info) ->*
  log 'update problem', to-server-fmt info
  yield request \post, "/problem/#{pid}" .send to-server-fmt info .end!

  return
    type: \problem/update,
    payload: info

export on-refresh-problem-list = co.wrap ->*
  data = yield request \get, \/problem .end!

  return
    type: \problem/refresh-list
    payload: data.body

export on-get-problem = co.wrap (pid, load, mode = "") ->*
  data = yield request \get, "/problem/#{pid}/#{mode}" .end!
  data.body.load = load

  return
    type: \problem/get
    payload: data.body

export on-submit-solution = co.wrap (data) ->*
  res = yield request \post, \/solution/submit .send data .end!

  return
    type: \solution/submit
    payload: res.body

export on-get-solutions-list = co.wrap ->*
  data = yield request \get, \/solution .end!

  return
    type: \solution/list
    payload: data.body

export on-get-solution = co.wrap (sid) ->*
  data = yield request \get, "/solution/#{sid}" .end!
  return
    type: \solution/get
    payload: data.body

  # co.wrap (add-jwt, dispatch) ->*
  #   data = yield request \get, "/solution/#{sid}" .end!
  #
  #   dispatch do
  #     type: \solution/get
  #     payload: data.body

export on-get-round = co.wrap (rid, load, mode = "") ->*
  data = yield request \get, "/round/#{rid}/#{mode}" .end!
  data.body.load = load
  return
    type: \round/get
    payload: data.body

export on-upload-files = co.wrap (pid, files) ->*
  log {files}
  req = request \post, "/data/#{pid}/upload"
  for f in files
    req.attach f.name, f
  data = yield req.end!

  return
    type: \problem/upload
    payload: [f.name for f in files]

export on-add-prob-to-round = co.wrap (pid) ->*
  prob-info = yield request \get, "/problem/#{pid}/brief" .end!

  return
    type: \round/add-prob
    payload: prob-info.body

export on-round-modify = co.wrap (rnd) ->*
  ret = yield request \post, "/round/#{rnd.rid}" .send rnd .end!

  return
    type: \round/modify
    payload: null

export on-get-rounds-list = co.wrap ->*
  return
    type: \round/list
    payload: yield request \get, "/round" .end!

export on-get-round-board = co.wrap (rid) ->*
  return
    type: \round/board
    payload: yield request \get, "/round/#{rid}/board" .end!

export on-get-user-privileges = co.wrap (uid) ->*
  return
    type: \user/privileges
    payload: yield request \get, "/user/#{uid}/privileges" .end!

export on-update-user = co.wrap (uid, updated) ->*
  return
    type: \user/update
    payload: yield request \post, "/user/#{uid}" .send updated .end!
