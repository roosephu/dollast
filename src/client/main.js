import Vue from 'vue'
import VueApollo from 'vue-apollo'
import { ApolloClient } from 'apollo-client'
import { createUploadLink } from 'apollo-upload-client'
import { InMemoryCache } from 'apollo-cache-inmemory'
import { debug } from 'debug'
import router from './router'
import store from './store'
import App from '@/components/app'

debug.enable('dollast:*')
// const log = debug('dollast:main')

// axios.defaults.baseURL = '/api'

// Create the apollo client
const apolloProvider = new VueApollo({
  defaultClient: new ApolloClient({
    link: createUploadLink({
      uri: 'http://localhost:3000/graphql',
      credentials: 'same-origin'
    }),
    cache: new InMemoryCache(),
    connectToDevTools: true
  })
})

Vue.use(VueApollo)

new Vue({
  el: '#app',
  router,
  store,
  apolloProvider,
  components: {App},
  template: '<App />'
})

if (MathJax) {
  MathJax.Hub.Config({
    tex2jax: {
      inlineMath: [
        ['$', '$'],
        ['\\(', '\\)']
      ]
    }
  })
}

if (module.hot) {
  module.hot.accept()
}
