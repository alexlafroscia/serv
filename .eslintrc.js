'use strict';

module.exports = {
  parser: 'babel-eslint',
  env: { browser: true, es6: true },
  extends: ['eslint:recommended', 'prettier', 'prettier/react'],
  plugins: ['prettier', 'react'],
  rules: {
    // Prettier
    'prettier/prettier': [
      'error',
      {
        singleQuote: true
      }
    ],

    // JSX
    'react/jsx-uses-react': 'error',
    'react/jsx-uses-vars': 'error'
  },
  settings: {
    react: {
      pragma: 'h'
    }
  }
};
