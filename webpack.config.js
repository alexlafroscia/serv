const path = require('path');

module.exports = {
  entry: path.resolve(__dirname, "ui/index.js"),
  output: {
    path: path.resolve(__dirname, "./priv/static/js/"),
    filename: "app.js"
  }
};
