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
    \prismjs
    \prelude-ls
    \moment
    \flat
    \axios

module.exports =
  entry:
    app: './client/main'
    vendor: vendors
  resolve:
    extensions: [\.js, \.vue, \.ls, \.coffee, \css]
    alias:
      moment: "moment/min/moment-with-locales.min"
  module:
    rules:
      * test: /\.vue$/
        loader: 'vue-loader'
        options:
          loaders:
            js: \vue-livescript-loader
      * test: /\.ls$/
        loader: 'livescript-loader'
      * test: /\.css$/
        loader: 'style-loader!css-loader'
      * test: /\.js$/
        loader: 'babel-loader'
  output:
    path: path.join __dirname, \../public
    filename: \app.js
    public-path: \/
  plugins: [
    new webpack.optimize.CommonsChunkPlugin name: \vendor, filename: \vendors.js
    new webpack.ContextReplacementPlugin /\.\/locale$/, 'empty-module', false, /js$/
    # new webpack.optimize.OccurenceOrderPlugin!
    new webpack.NoEmitOnErrorsPlugin!
    new webpack.DefinePlugin do
      'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV || '"development"')
  ]
