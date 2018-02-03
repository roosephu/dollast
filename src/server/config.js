import common from '../common'
import { resolve } from 'path'

export default {
  passGuest: false,
  mode: 'debug',
  concurrency: 3,
  keys: ['drdrd'],
  dataDir: resolve('./data'),
  judgerDir: resolve('./utils/judgers'),
  judgers: common.judgers,
  imageDir: 'public/images',
  default: {
    theme: 'vue',
    groups: {}
  },
  bcryptCost: 10,
  jwtKey: 'drdrdrd',
  serverAESKey: 'da63af5c90e00d60aa3ddd0793a6e3ca6a8284b0fa8884bba72602ec3719c661',
  startingIds: {
    submission: 1,
    problems: 1,
    rounds: 1
  },
  session: {
    key: 'session',
    maxAge: 1000 * 60 * 60 * 24,
    httpOnly: false
  }
}
