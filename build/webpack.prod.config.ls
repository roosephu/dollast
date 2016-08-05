require! {
  \webpack
  \webpack-merge
  \./webpack.base.config : base
}

module.exports = webpack-merge base,
  vue:
    loaders:
      js: 'babel?presets[]=es2015&plugins=transform-runtime!livescript'
  plugins: [
    new webpack.optimize.CommonsChunkPlugin \vendor, \vendors.js
    new webpack.optimize.OccurenceOrderPlugin!
    new webpack.NoErrorsPlugin!
    new webpack.DefinePlugin 'process.env.NODE_ENV': '"production"'
    new webpack.optimize.UglifyJsPlugin do
      compress:
        warnings: false
  ]
