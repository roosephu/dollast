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
  plugins: [
    new webpack.optimize.CommonsChunkPlugin name: \vendor, filename: \vendors.js
    # new webpack.optimize.OccurenceOrderPlugin!
    new webpack.NoEmitOnErrorsPlugin!
    new webpack.DefinePlugin 'process.env.NODE_ENV': '"development"'
  ]
