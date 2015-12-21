app = angular.module "dollast-sess", ["dollast-crud", "angular-jwt"]

pub-key = '''
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCV8qwyGUz1mKUNyMUXIb5THUYJ
9Xf9WgL/GC5UeVon7JKtzeWXRSCmzxlO5XD4GD8zcJ728kNfABdizPQ1HG4MFfRc
s5vPQDiIR23dafkGODmE039aKRiTc+xxrLgx3huasFan+2yG/tiFQbXEFfAmLaal
6FuOukBTwitq0XBdiQIDAQAB
-----END PUBLIC KEY-----
'''

RSA-enc = forge.pki.public-key-from-pem pub-key

app.service "user-session", [
  "site-serv", "user-serv", "jwtHelper"
  (site-serv, user-serv, jwt-helper) ->
    sess =
      load-token: ->
        token = local-storage.token
        return if not token
        try
          payload = jwt-helper.decode-token token
          console.log payload
          sess.uid = payload._ \i,d
          sess.priv = payload.priv
        catch e
          console.log e
      logout: ->
        delete local-storage.token
        delete sess.uid
      enc: (pswd, callback) ->
        site-serv.get mode: "token", ->
          salted-pswd = it.salt + pswd
          enc-pswd = forge.util.encode64 RSA-enc.encrypt salted-pswd
          callback enc-pswd
      login: (uid, pswd) ->
        sess.enc pswd, ->
          site-serv.login _ \i,d: uid, pswd: it, ->
            console.log it
            local-storage.token = it.token
            sess.load-token!
      register: (uid, pswd) ->
        sess.enc pswd, ->
          user-serv.reg uid: uid, pswd: it, ->
            console.log it
]
