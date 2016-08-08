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
    \prismjs
    \prelude-ls
    \moment
    \flat

module.exports = 
  entry:
    app: './client/main'
    vendor: vendors
  resolve:
    extensions: [\.js, \.vue, \.ls, "", \.coffee, \css]
    alias: 
      moment: "moment/min/moment-with-locales.min"
  module:
    loaders:
      * test: /\.vue$/
        loader: 'vue'
      * test: /\.ls$/
        loader: 'livescript'
      * test: /\.css$/
        loader: 'style!css'
  output:
    path: path.join __dirname, \../public
    filename: \app.js
    public-path: \/
  plugins: [
    new webpack.optimize.CommonsChunkPlugin \vendor, \vendors.js
    new webpack.ContextReplacementPlugin /\.\/locale$/, 'empty-module', false, /js$/
    new webpack.optimize.OccurenceOrderPlugin!
    new webpack.NoErrorsPlugin!
    new webpack.DefinePlugin do
      'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV || '"development"')
  ]