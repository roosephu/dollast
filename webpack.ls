require! {
  \path
  # \webpack
}

vendors = [
    \react,
    \redux,
    \redux-actions,
    \react-redux,
    \immutable,
    \co,
    \debug,
    \superagent,
    \superagent-promise,
    \bluebird,
    \react-highlight,
    \react-router,
    \redux-devtools/lib/react,
    \react-dropzone,
    \prelude-ls,
    \redux-promise,
    \redux-logger,
    \redux-devtools,
]

module.exports = config =
  debug: true
  watch: true
  entry:
    app: \./public/js/dollast/app
    # vendors: vendors
  output:
    path: path.join __dirname, \public/js
    filename: \app.js
    public-path: \/static/
    #library: \require
    #library-target: \commonjs
  #externals: {[x, "require(\"#{x}\")"] for x in externals}
  plugins: [
    # new webpack.optimize.CommonsChunkPlugin \vendors,  \vendors.js
    #new webpack.optimize.UglifyJsPlugin do
      #compress:
        #warnings: false
  ]
#
#webpack config, (err, res) ->
  #console.log "done"
