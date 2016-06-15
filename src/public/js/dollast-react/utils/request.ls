require! {
  \co
  \superagent
  \superagent-promise
  #\superagent-defaults
}

log = debug 'dollast:request'

gen-new-client-key = ->
  forge.util.bytes-to-hex forge.random.get-bytes-sync 32

get-client-key = ->
  {client-key} = local-storage
  if not client-key
    client-key = gen-new-client-key!
    local-storage.client-key = client-key
  client-key

client-sign = (txt) ->
  txt
  #client-key = get-client-key!
  #cipher-txt = AES-enc
#
  #h = forge.hmac.create!
  #h.start 'sha256', key
  #h.update txt
  #sig = forge.util.encode64 forge.util.hex-to-bytes h.digest!.to-hex!
  #
  #payload =
    #key: forge.util.encode64 RSA-enc.encrypt client-key
    #sig: sig
#
  #header = alg: 'HS256', typ: 'JWT'
  #sig: jwt-encode header, payload, client-key
  #body: AES-enc txt, client-key

promise = @Promise || require \bluebird

#superagent = superagent-defaults!

#module.exports = request

default-headers = {}

request = (method, url) ->
  agent = superagent-promise superagent, promise
  agent method, url .set default-headers

request.set-headers = (field, value) ->
  if field == Object field
    for key, val of field
      default-headers[key] = val
  else
    default-headers[field] = value

module.exports = request

#export request = promise
#
#export request = (func) ->
  #(dispatch, get-state) ->
    #my-request.token = get-state!.get-in [\session, \token], null
    #log my-request
    #func my-request

#export request = superagent-promise superagent, promise
#
#export finalize = (get-state, request) ->
  #token = get-state!.get-in [\session, \token], null
  #if token
    #request.set \Authorization, token
  #request.end!

#
#module.exports = co.wrap (method, url, payload) ->*
  #try
    #if payload
      #signed-data = client-sign JSON.stringify payload
    #else
      #signed-data = null
    #ret = yield $[method] url, signed-data
    #log {method, url, payload}
  #catch e
    #ret =
      #type: "internal error"
      #payload: e
    #log 'request error', e
  #ret
