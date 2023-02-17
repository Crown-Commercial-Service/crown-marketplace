process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')
const ForkTsCheckerWebpackPlugin = require("fork-ts-checker-webpack-plugin")
const path = require("path")

environment.plugins.append(
  "ForkTsCheckerWebpackPlugin",
  new ForkTsCheckerWebpackPlugin({
    // this is a relative path to your project's TypeScript config
    typescript: {
      configFile: path.resolve(__dirname, "../../tsconfig.json"),
    },

    // non-async so type checking will block compilation
    async: false,
  })
)

module.exports = environment.toWebpackConfig()
