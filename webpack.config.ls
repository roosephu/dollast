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
    \prelude-ls
    \moment

module.exports = config =
  debug: true
  watch: true
  entry:
    app:
      * './client/main.ls'
        'webpack-hot-middleware/client?http://localhost:3000'
        'webpack/hot/dev-server'
        'eventsource-polyfill'
    vendor: vendors
    # vendors ++ ['webpack/hot/dev-server', 'webpack-hot-middleware/client', './client/main.ls']
  resolve:
    extensions: [\.js, \.vue, \.ls, "", \.coffee]
  module:
    loaders:
      * test: /\.vue$/
        loader: \vue
      * test: /\.ls$/
        loader: \vue-livescript
  output:
    path: path.join __dirname, \public/js
    filename: \app.js
    public-path: \/assets/
    #library: \require
    #library-target: \commonjs
  #externals: {[x, "require(\"#{x}\")"] for x in externals}
  plugins: [
    new webpack.optimize.CommonsChunkPlugin \vendor, \vendors.js
    new webpack.optimize.OccurenceOrderPlugin!
    new webpack.HotModuleReplacementPlugin!
    new webpack.NoErrorsPlugin!
    new webpack.DefinePlugin do
      'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV || '"development"')
    # new webpack.optimize.UglifyJsPlugin do
    #   compress:
    #     warnings: false
  ]
#
#webpack config, (err, res) ->
  #console.log "done"
