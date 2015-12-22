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

export on-login = (info) ->
  co.wrap (add-jwt, dispatch) ->*
    log "store received", info
    ret = yield request \post, \/site/login .send info .use add-jwt .end!
    dispatch on-load-from-token ret.body.token

export on-register = (info) ->
  co.wrap (add-jwt, dispatch) ->*
    data = yield request \post, \/user/register .send info .use add-jwt .end!

    dispatch do
      type: \register
      payload: data.body

export on-logout = create-action 'logout', ->
  delete local-storage.token
  null

export on-update-problem = (pid, info) ->
  co.wrap (add-jwt, dispatch) ->*
    log 'update problem', to-server-fmt info
    yield request \post, "/problem/#{pid}" .send to-server-fmt info .use add-jwt .end!

    dispatch do
      type: \problem/update,
      payload: info

export on-refresh-problem-list = ->
  co.wrap (add-jwt, dispatch) ->*
    data = yield request \get, \/problem .end!

    dispatch do
      type: \problem/refresh-list
      payload: data.body

export on-get-problem = (pid, load, mode = "") ->
  co.wrap (add-jwt, dispatch) ->*
    data = yield request \get, "/problem/#{pid}/#{mode}" .use add-jwt .end!
    data.body.load = load

    dispatch do
      type: \problem/get
      payload: data.body

export on-submit-solution = (data) ->
  co.wrap (add-jwt, dispatch) ->*
    res = yield request \post, \/solution/submit .send data .use add-jwt .end!

    dispatch do
      type: \solution/submit
      payload: res.body

export on-get-solutions-list = ->
  co.wrap (add-jwt, dispatch) ->*
    data = yield request \get, \/solution .use add-jwt .end!

    dispatch do
      type: \solution/list
      payload: data.body

export on-get-solution = (sid) ->
  co.wrap (add-jwt, dispatch) ->*
    data = yield request \get, "/solution/#{sid}" .use add-jwt .end!

    dispatch do
      type: \solution/get
      payload: data.body

export on-get-round = (rid, load, mode = "") ->
  co.wrap (add-jwt, dispatch) ->*
    data = yield request \get, "/round/#{rid}/#{mode}" .use add-jwt .end!
    data.body.load = load

    dispatch do
      type: \round/get
      payload: data.body

export on-upload-files = (pid, files) ->
  co.wrap (add-jwt, dispatch) ->*
    log {files}
    req = request \post, "/data/#{pid}/upload"
    for f in files
      req.attach f.name, f
    data = yield req.use add-jwt .end!

    dispatch do
      type: \problem/upload
      payload: [f.name for f in files]

export on-add-prob-to-round = (pid) ->
  co.wrap (add-jwt, dispatch) ->*
    prob-info = yield request \get, "/problem/#{pid}/brief" .use add-jwt .end!

    dispatch do
      type: \round/add-prob
      payload: prob-info.body
