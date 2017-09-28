/* eslint-env node */

const path = require('path');

module.exports = {
  entry: path.resolve(__dirname, './apps/serv_web/ui/index.js'),
  output: {
    path: path.resolve(__dirname, './apps/serv_web/priv/static/js/'),
    filename: 'app.js'
  },
  module: {
    rules: [
      {
        test: /\.jsx?/i,
        loader: 'babel-loader',
        options: {
          babelrc: false,
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
          plugins: [['transform-react-jsx', { pragma: 'h' }]],
          env: {
            production: {
              presets: [
                [
                  'minify',
                  {
                    mangle: false
                  }
                ]
              ]
            }
          }
        }
      }
    ]
  }
};
