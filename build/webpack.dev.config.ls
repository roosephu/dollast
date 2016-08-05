require! {
  \webpack-merge
  \webpack
  \./webpack.base.config : base
}

module.exports = webpack-merge base,
  entry:
    app:
      * './client/main.ls'
        'webpack-hot-middleware/client?http://localhost:3000'
        'webpack/hot/dev-server'
        'eventsource-polyfill'
  vue:
    loaders:
      js: \livescript
  plugins: [
    new webpack.optimize.CommonsChunkPlugin \vendor, \vendors.js
    new webpack.optimize.OccurenceOrderPlugin!
    new webpack.HotModuleReplacementPlugin!
    new webpack.NoErrorsPlugin!
    new webpack.DefinePlugin 'process.env.NODE_ENV': '"development"'
  ]
