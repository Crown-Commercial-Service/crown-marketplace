const { env, webpackConfig, merge } = require('shakapacker');

const customConfig = {
  module: {
    rules: [
      {
        test: require.resolve("jquery"),
        loader: "expose-loader",
        options: {
          exposes: [
            '$',
            'jQuery'
          ],
        },
      }
    ]
  },
  resolve: {
    extensions: ['.ts']
  }
};

let devConfig = {};

if (env.nodeEnv === 'development') {
  const ForkTSCheckerWebpackPlugin = require("fork-ts-checker-webpack-plugin");

  devConfig = {
    plugins: [new ForkTSCheckerWebpackPlugin()]
  };
}

module.exports = merge(webpackConfig, customConfig, devConfig);
