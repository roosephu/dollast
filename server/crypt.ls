require! {
  \node-forge
  \debug
  \koa-jwt
  \./config
}

log = debug "dollast:encrypt"

priv-key = '''
-----BEGIN RSA PRIVATE KEY-----
MIICWwIBAAKBgQCV8qwyGUz1mKUNyMUXIb5THUYJ9Xf9WgL/GC5UeVon7JKtzeWX
RSCmzxlO5XD4GD8zcJ728kNfABdizPQ1HG4MFfRcs5vPQDiIR23dafkGODmE039a
KRiTc+xxrLgx3huasFan+2yG/tiFQbXEFfAmLaal6FuOukBTwitq0XBdiQIDAQAB
AoGAZfrxmfETIkV6m/Fb+et9IdHa/JLx1GEPgKbVe6Y85sJCz+okp8jf+BMJx1rM
hi8XbMi/lHwXzdimDxANVsHLJWWbydu7PfcNS5EjQpWJgrEb4bdg0Tkyk5Baj5tr
LwOw9lzY7uOem6kJaKCBcNKJet7nSjoO23zODifxQFmrOjECQQDtqwbdBEeVk8jF
vY8XBdSWbkKwHN7yQpPgnwQ5VdDP9MkZYieAdZGRGkXn1Q6xRG562ASbd8Xo7yjI
mV7bHOkfAkEAoYOIG7bs/fOmIRbo45I4EprV9SV1b6blqrNo3hUx/OXzfS6ml1Q8
z6cIuxG0YexzTW7kAmDwMncsRd7qkGpcVwJAKaKxhByQ0dJe9M09eQILeQL96c5U
/EnPkCUrX0P6XcP7StgYJXfzNWFN58w6U7GyTRD01auI30KueV3s8SPCbwJAen5v
M9XAV7n6PQ5LAo1ayYF007/dGRjTBmubFROuHceoq0A+SHcyx6o/DOGYlMvnhsqb
UtKCWUPY6ATwkSaZcQJAF+aQSxmuI6tLztjwxgzq0ZpaM5iKZQFAzNEUVB8DXG46
AO4I2wqKqyCspNQOkqGu1cTtsCvMsnrOGy4UfDPKWA==
-----END RSA PRIVATE KEY-----
'''
pub-key = '''
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCV8qwyGUz1mKUNyMUXIb5THUYJ
9Xf9WgL/GC5UeVon7JKtzeWXRSCmzxlO5XD4GD8zcJ728kNfABdizPQ1HG4MFfRc
s5vPQDiIR23dafkGODmE039aKRiTc+xxrLgx3huasFan+2yG/tiFQbXEFfAmLaal
6FuOukBTwitq0XBdiQIDAQAB
-----END PUBLIC KEY-----
'''

RSA-enc = node-forge.pki.public-key-from-pem pub-key
RSA-dec = node-forge.pki.private-key-from-pem priv-key

export
  RSA:
    dec: (data) ->
      JSON.parse RSA-dec.decrypt node-forge.util.decode64 data

    enc: (data) ->
      log RSA-enc.encrypt "fdaf"
      node-forge.util.encode64 RSA-enc.encrypt JSON.stringify data

  AES:
    enc: (plain, key) ->
      # log {plain, key}
      iv = node-forge.util.hex-to-bytes key.substr 32
      key = node-forge.util.hex-to-bytes key.substr 0, 32
      cipher = node-forge.cipher.create-cipher 'AES-CBC', key
      cipher.start {iv}
      cipher.update node-forge.util.create-buffer plain
      cipher.finish!
      encrypted = cipher.output
      encrypted.to-hex!

    dec: (cipher, key) ->
      iv = node-forge.util.hex-to-bytes key.substr 32
      key = node-forge.util.hex-to-bytes key.substr 0, 32
      decipher = node-forge.cipher.create-decipher 'AES-CBC', key
      decipher.start {iv}
      decipher.update node-forge.util.create-buffer node-forge.util.hex-to-bytes cipher
      decipher.finish!
      decipher.output.data

  # verify: (request, client-key) ->
  #   try
  #     koa-jwt.verify request, client-key
  #   catch
  #     log e
  #     throw new Error "wrong salt detected"
  #   data

  # gen-salt: ->
  #   bytes = node-forge.random.get-bytes-sync 8
  #   salt = node-forge.util.bytes-to-hex bytes
  #   claims = {salt}
  #   koa-jwt.sign claims, config.secret, expires-in-seconds: 60 * 5
