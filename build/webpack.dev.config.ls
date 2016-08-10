require! {
  \webpack-merge
  \webpack
  \./webpack.base.config : base
}

module.exports = webpack-merge base,
  entry:
    app:
      * './client/main'
  output:
    public-path: 'http://localhost:8080/'
  vue:
    loaders:
      js: \livescript
  plugins: [
    new webpack.optimize.CommonsChunkPlugin \vendor, \vendors.js
    new webpack.optimize.OccurenceOrderPlugin!
    new webpack.NoErrorsPlugin!
    new webpack.DefinePlugin 'process.env.NODE_ENV': '"development"'
  ]
