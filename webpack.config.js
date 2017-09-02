/* eslint-env node */

const path = require('path');

module.exports = {
  entry: path.resolve(__dirname, 'ui/index.js'),
  output: {
    path: path.resolve(__dirname, './priv/static/js/'),
    filename: 'app.js'
  },
  module: {
    rules: [
      {
        test: /\.jsx?/i,
        loader: 'babel-loader',
        options: {
          presets: [
            [
              'env',
              {
                targets: {
                  browsers: ['last 1 Chrome versions']
                }
              }
            ]
          ],
          plugins: [['transform-react-jsx', { pragma: 'h' }]]
        }
      }
    ]
  }
};
