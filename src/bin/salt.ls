require! {
  "node-forge"
  "crypto"
  "debug"
  "prelude-ls": _
}

log = debug "dollast:salt"

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

RSA = node-forge.pki.private-key-from-pem priv-key

export
  unsalt: (pswd, ctx) ->
    log pswd
    salted-pswd = RSA.decrypt node-forge.util.decode64 pswd
    [salt, pswd] = _.split-at 16, salted-pswd
    log salted-pswd, salt, pswd
    if not ctx?.session?.salt? or salt != ctx.session.salt
      throw new Error "wrong salt detected"
    return pswd

  gen-salt: ->
    bytes = crypto.random-bytes 8
    return bytes.to-string 'hex'
