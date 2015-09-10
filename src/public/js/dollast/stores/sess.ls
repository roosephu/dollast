require! {
  \reflux
  \co
}

export actions = reflux.create-actions [
  * \login
  * \logout
  * \register
  * \loadToken
]

pub-key = '''
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCV8qwyGUz1mKUNyMUXIb5THUYJ
9Xf9WgL/GC5UeVon7JKtzeWXRSCmzxlO5XD4GD8zcJ728kNfABdizPQ1HG4MFfRc
s5vPQDiIR23dafkGODmE039aKRiTc+xxrLgx3huasFan+2yG/tiFQbXEFfAmLaal
6FuOukBTwitq0XBdiQIDAQAB
-----END PUBLIC KEY-----
'''
RSA-enc = forge.pki.public-key-from-pem pub-key

AES-dec = (cipher, key) ->
  iv = forge.util.hex-to-bytes key.substr 32
  key = forge.util.hex-to-bytes key.substr 0, 32
  decipher = forge.cipher.create-decipher 'AES-CBC', key
  decipher.start {iv}
  decipher.update forge.util.create-buffer forge.util.hex-to-bytes cipher
  decipher.finish!
  decipher.output.data

export store = reflux.create-store do
  listenables: actions

  gen-new-client-key: ->
    forge.util.bytes-to-hex forge.random.get-bytes-sync 32

  get-client-key: ->
    {client-key} = local-storage
    if not client-key
      client-key = @gen-new-client-key!
      local-storage.client-key = client-key
    client-key

  set-jwt: (token) ->
    old-settings = $.ajax-setup!
    $.ajax-setup old-settings <<<<
      headers:
        Authorization: "Bearer #{token}"

  get-initial-state: ->
    uid: ""

  on-load-token: ->
    {token} = local-storage
    if token
      @set-jwt token
      jwt-struct = token.split '.'
      while jwt-struct[1].length % 3 != 0
        jwt-struct[1] += "="
      payload = JSON.parse forge.util.decode64 jwt-struct[1] + "="
      @state = JSON.parse AES-dec payload.client, @get-client-key!
      @trigger @state

    # return
    # return if not token
    # try
    #   payload = jwt-helper.decode-token token
    #   console.log payload
    #   sess.uid = payload._id
    #   sess.priv = payload.priv
    # catch e
    #   console.log e

  jwt-encode: (header, payload, key) ->
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

  client-sign: (data) ->
    client-key = @get-client-key!
    payload = content: forge.util.encode64 RSA-enc.encrypt JSON.stringify data <<<< {client-key}
    header = alg: 'HS256', typ: 'JWT'
    #KJUR.jws.JWS.sign "HS256", header, payload, client-key
    signed: @jwt-encode header, payload, client-key

  on-login: co.wrap (info) ->*
    console.log "store received", info
    ret = yield $.post '/site/login', @client-sign info
    console.log ret
    local-storage.token = ret.token
    actions.load-token!

  on-register: co.wrap (info) ->*
    ret = yield $.post '/user/register', @client-sign enc-info
    console.log "return:", ret

  on-logout: ->
    delete local-storage.token
    @set-state uid: ""
# console.log store.jwt-encode {"alg":"HS256","typ":"JWT"}, {"loggedInAs":"admin","iat":1422779638}, 'secretkey'
