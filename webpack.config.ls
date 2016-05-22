require! {
  \path
  \webpack
}

vendors = [
    \co
    \debug
    \vue
    \vuex
    \vue-router
    \vue-resource
    \prelude-ls
    \moment
]

module.exports = config =
  debug: true
  watch: true
  entry:
    app: \./src/public/js/dollast/main.ls
    vendors: vendors
  resolve:
    extensions: [\.js, \.vue, \.ls, "", \.coffee]
  module:
    loaders:
      * test: /\.vue$/
        loader: \vue
      * test: /\.ls$/
        loader: \vue-livescript-loader
  output:
    path: path.join __dirname, \public/js
    filename: \app.js
    public-path: \/static/
    #library: \require
    #library-target: \commonjs
  #externals: {[x, "require(\"#{x}\")"] for x in externals}
  plugins: [
    new webpack.optimize.CommonsChunkPlugin \vendors,  \vendors.js
    # new webpack.optimize.UglifyJsPlugin do
      # compress:
        # warnings: false
  ]
#
#webpack config, (err, res) ->
  #console.log "done"
