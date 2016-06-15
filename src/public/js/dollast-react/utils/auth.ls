
pub-key = '''
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCV8qwyGUz1mKUNyMUXIb5THUYJ
9Xf9WgL/GC5UeVon7JKtzeWXRSCmzxlO5XD4GD8zcJ728kNfABdizPQ1HG4MFfRc
s5vPQDiIR23dafkGODmE039aKRiTc+xxrLgx3huasFan+2yG/tiFQbXEFfAmLaal
6FuOukBTwitq0XBdiQIDAQAB
-----END PUBLIC KEY-----
'''

RSA-entity = forge.pki.public-key-from-pem pub-key

log = debug 'dollast:auth'

export
  RSA:
    enc: (txt) ->
      txt

    dec: (cipher, key) ->
      return cipher
      #iv = forge.util.hex-to-bytes key.substr 32
      #key = forge.util.hex-to-bytes key.substr 0, 32
      #decipher = forge.cipher.create-decipher 'AES-CBC', key
      #decipher.start {iv}
      #decipher.update forge.util.create-buffer forge.util.hex-to-bytes cipher
      #decipher.finish!
      #decipher.output.data

  jwt:
    enc: (header, payload, key) ->
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

    dec: (token) ->
      jwt-struct = token.split '.'
      while jwt-struct[1].length % 4 != 0
        jwt-struct[1] += "="
      #log forge.util.decode64 jwt-struct[1]
      payload = JSON.parse forge.util.decode64 jwt-struct[1]
