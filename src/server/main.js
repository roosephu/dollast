import Koa from 'koa'
import KoaRouter from 'koa-router'
import KoaBody from 'koa-bodyparser'
import KoaJson from 'koa-json'
import KoaSend from 'koa-send'
import KoaCompress from 'koa-compress'
import KoaConditioanlGet from 'koa-conditional-get'
import KoaEtag from 'koa-etag'
import KoaSession from 'koa-session'
import { debug } from 'debug'
import { graphqlKoa, graphiqlKoa } from 'apollo-server-koa'
import { apolloUploadKoa } from 'apollo-upload-server'
import schema from './models/connectors'
import { resolve } from 'path'
import config from './config'

var log = debug('dollast:server')

const app = new Koa()

app.keys = config.keys
app.use(KoaCompress())
app.use(KoaBody())
app.use(KoaEtag())
app.use(KoaJson())
app.use(KoaConditioanlGet())
app.use(KoaSession(config.session, app))

const router = new KoaRouter()

app.use(async (ctx, next) => {
  // log('session: ', ctx.session)
  await next()
})

const options = (ctx) => {
  return {
    schema,
    context: ctx
  }
}

router.post('/graphql', KoaBody(), apolloUploadKoa(), graphqlKoa(options))
router.get('/graphql', graphqlKoa(options))
router.get('/graphiql', graphiqlKoa({ endpointURL: '/graphql' }))

app.use(router.routes())
app.use(router.allowedMethods())

app.use(async (ctx, next) => {
  const theme = 'vue'
  if (ctx.method === 'HEAD' || ctx.method === 'GET') {
    for (const folder of ['public', `theme/${theme}`]) {
      try {
        await KoaSend(ctx, ctx.path, {
          index: 'index.html',
          maxAge: 64000000,
          root: resolve(folder)
        })
        return
      } catch (err) {
      }
    }
  }
  await next()
})

app.use(async (ctx, next) => {
  ctx.body = '404!'
})

const port = 3000
log(`Listening port ${port}`)
app.listen(port)
