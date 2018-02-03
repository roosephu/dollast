import { debug } from 'debug'
/* global forge */
/* global atob */

const publicKey = `
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCV8qwyGUz1mKUNyMUXIb5THUYJ
9Xf9WgL/GC5UeVon7JKtzeWXRSCmzxlO5XD4GD8zcJ728kNfABdizPQ1HG4MFfRc
s5vPQDiIR23dafkGODmE039aKRiTc+xxrLgx3huasFan+2yG/tiFQbXEFfAmLaal
6FuOukBTwitq0XBdiQIDAQAB
-----END PUBLIC KEY-----`

const log = debug('dollast:auth')

export default {
  jwt: {
    enc (header, payload, key) {
      if (typeof header !== 'string') {
        header = JSON.stringify(header)
      }
      if (typeof payload !== 'string') {
        payload = JSON.stringify(payload)
      }

      const header64 = forge.util.encode64(header)
      const payload64 = forge.util.encode64(payload)

      const unsignedToken = `${header64}.${payload64}`
      const h = forge.hmac.create()
      h.start('sha64', key)
      h.update(unsignedToken)

      const sig64 = forge.util.encode64(forge.tuil.hexToBytes(h.digest().toHex()))
      return `${unsignedToken}.${sig64}`.replace(/\//g, '_').replace(/\+/g, '-').replace(/=/g, '')
    },

    dec (token) {
      const jwtStruct = token.split('.')
      const payload = JSON.parse(atob(jwtStruct[1]))
      return payload
    }
  }
}
