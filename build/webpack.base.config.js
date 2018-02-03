import { join, resolve } from 'path'
import webpack from 'webpack'

const vendors = [
  'co',
  'debug',
  'vue',
  'vuex',
  'vue-router',
  'prismjs',
  'prelude-ls',
  'moment',
  'flat',
  'axios',
  'apollo-cache-inmemory',
  'vue-apollo',
  'apollo-link-http',
  'apollo-client',
  'babel-polyfill',
  'graphql-tag'
]

export default {
  entry: {
    app: ['babel-polyfill', './src/client/main'],
    vendor: vendors
  },
  resolve: {
    extensions: ['.ts', '.js', '.vue', '.ls', '.coffee', '.css'],
    alias: {
      moment: 'moment/min/moment-with-locales.min',
      'vue$': 'vue/dist/vue.esm.js',
      '@': join(__dirname, '..', 'src', 'client')
    }
  },
  module: {
    rules: [{
      test: /\.vue$/,
      loader: 'vue-loader'
    }, {
      test: /\.ts$/,
      loader: 'ts-loader'
    }, {
      test: /\.css$/,
      loader: 'style-loader!css-loader'
    }, {
      //   # options:
      //   #   loaders:
      //   #     js: "vue-livescript-loader
      // # * test: /".ls$/
      // #   loader: 'vue-livescript-loader'
      test: /\.js$/,
      // # exclude: /node_modules/
      include: [
        resolve(__dirname, 'src', 'client'),
        resolve(__dirname, 'node_modules', 'vue-livescript-loader')
      ],
      loader: 'babel-loader'
    }]
  },
  output: {
    path: join(__dirname, '../public'),
    filename: 'app.js',
    publicPath: 'http://localhost:8080/'
  },
  plugins: [
    new webpack.optimize.CommonsChunkPlugin({
      name: 'vendor',
      filename: 'vendors.js'
    }),
    new webpack.ContextReplacementPlugin(/\.\/locale$/, 'empty-module', false, /js$/),
    new webpack.NoEmitOnErrorsPlugin(),
    new webpack.NamedModulesPlugin(),
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV || '"development"')
    })
  ],
  stats: 'minimal'
  // dev-server:
  //   quiet: false
  //   no-info: false
  //   stats:
  //     assets: false
  //     colors: true
  //     version: false
  //     hash: false
  //     timings: false
  //     chunks: false
  //     chunk-modules: false

}
