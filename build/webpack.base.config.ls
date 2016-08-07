require! {
  \path
  \webpack
}

vendors =
  * \co
    \debug
    \vue
    \vuex
    \vue-router
    \vue-resource
    # \node-forge
    \prelude-ls
    \moment
    \flat

module.exports = 
  entry:
    app: './client/main'
    vendor: vendors
  resolve:
    extensions: [\.js, \.vue, \.ls, "", \.coffee]
    alias: 
      moment: "moment/min/moment-with-locales.min"
  module:
    loaders:
      * test: /\.vue$/
        loader: 'vue'
      * test: /\.ls$/
        loader: 'livescript'
  output:
    path: path.join __dirname, \../public/assets
    filename: \app.js
    public-path: \/assets/
  plugins: [
    new webpack.optimize.CommonsChunkPlugin \vendor, \vendors.js
    new webpack.ContextReplacementPlugin /\.\/locale$/, 'empty-module', false, /js$/
    new webpack.optimize.OccurenceOrderPlugin!
    new webpack.NoErrorsPlugin!
    new webpack.DefinePlugin do
      'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV || '"development"')
  ]