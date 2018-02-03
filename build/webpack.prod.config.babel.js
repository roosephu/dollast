import base from './webpack.base.config'
import merge from 'webpack-merge'
import webpack from 'webpack'

export default merge(base, {
  plugins: [
    new webpack.optimize.CommonsChunkPlugin({
      name: 'vendor',
      filename: 'vendors.js'
    }),
    new webpack.NoEmitOnErrorsPlugin(),
    new webpack.DefinePlugin({ 'process.env.NODE_ENV': '"production"' })
  ]
})
