require! {
  \debug
}

log = debug 'dollast:auth'

export encode = (header, payload, key) ->
  # console.log header, payload, key
  if 'string' != typeof header
    header = JSON.stringify header
  if 'string' != typeof payload
    payload = JSON.stringify payload
  header64 = forge.util.encode64 header
  payload64 = forge.util.encode64 payload
  unsigned-token = "#{header64}.#{payload64}"
  h = forge.hmac.create!
  h.start 'sha256', key
  h.update unsigned-token
  signature64 = forge.util.encode64 forge.util.hex-to-bytes h.digest!.to-hex!
  ret = "#{unsigned-token}.#{signature64}".replace /\//g, '_' .replace /\+/g, '-' .replace /\=/g, ''
  # ret.substr 0, ret.length - 1
  ret

export decode = (token) ->
  jwt-struct = token.split '.'
  payload = JSON.parse atob jwt-struct[1]
  header = JSON.parse atob jwt-struct[0]

  {payload, header}