const path = require('path')
const webpack = require('webpack')
const merge = require('webpack-merge')
const ExtractCssChunks = require('extract-css-chunks-webpack-plugin')
const CaseSensitivePathsPlugin = require('case-sensitive-paths-webpack-plugin')
const WatchMissingNodeModulesPlugin = require('react-dev-utils/WatchMissingNodeModulesPlugin')
const CssNanoPlugin = require('cssnano')
const TerserWebpackPlugin = require('terser-webpack-plugin')
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin')
const WriteFilePlugin = require('write-file-webpack-plugin')

module.exports = (env) => {
  const isDevBuild = !(env && env.prod)

  // Configuration in common to both client-side and server-side bundles.
  const sharedConfig = () => {
    var mode = isDevBuild ? 'development' : 'production'

    console.log('\x1b[36m%s\x1b[0m', '=== Webpack compilation mode: ' + mode + ' ===')

    var config = {
      mode,
      optimization: {
        minimize: !isDevBuild,
        usedExports: isDevBuild,
        minimizer: !isDevBuild ? [
          // Production.
          new TerserWebpackPlugin({
            terserOptions: {
              output: {
                comments: false
              }
            }
          }),
          new OptimizeCSSAssetsPlugin({
            cssProcessor: CssNanoPlugin,
            // @ts-ignore
            cssProcessorPluginOptions: {
              preset: ['default', { discardComments: { removeAll: true } }] }
          })
        ] : [
          // Development.
        ]
      },
      stats: { modules: false },
      resolve: {
        extensions: ['.js', '.jsx', '.jpg'],
        alias: {
          '@Layouts': path.resolve(__dirname, 'ClientApp/layouts/'),
          '@Ui': path.resolve(__dirname, 'ClientApp/Ui'),
          '@Components': path.resolve(__dirname, 'ClientApp/components/'),
          '@Images': path.resolve(__dirname, 'ClientApp/images/'),
          '@Store': path.resolve(__dirname, 'ClientApp/store/'),
          '@Utils': path.resolve(__dirname, 'ClientApp/utils'),
          '@Styles': path.resolve(__dirname, 'ClientApp/styles/'),
          '@Pages': path.resolve(__dirname, 'ClientApp/pages/'),
          '@Services': path.resolve(__dirname, 'ClientApp/services/'),
          '@Globals': path.resolve(__dirname, 'ClientApp/Globals'),
          'indexof': 'component-indexof/index'
        }
      },
      output: {
        filename: '[name].js',
        publicPath: 'dist/' // Webpack dev middleware, if enabled, handles requests for this URL prefix.
      },
      module: {
        rules: [
          {
            loader: 'babel-loader',
            test: /\.jsx$/,
            options: {
              presets: [
                ['@babel/preset-env', { modules: false, targets: { browsers: ['last 2 versions'] } }],
                '@babel/preset-react'
              ],
              cacheDirectory: true,
              plugins: [
                ['import', { libraryName: 'antd', style: true }],
                'transform-strict-mode',
                '@babel/plugin-proposal-object-rest-spread'
              ]
            }
          },
          {
            test: /\.(gif|png|jpe?g|svg)$/i,
            use: ['url-loader']
          }
        ]
      },
      plugins: [
        new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/)
      ].concat(isDevBuild ? [
        new webpack.NamedModulesPlugin(),
        new CaseSensitivePathsPlugin(),
        new WatchMissingNodeModulesPlugin(path.resolve(__dirname, '..', 'node_modules'))
      ] : [
        // Production.
      ])
    }

    if (isDevBuild) {
      config = {
        ...config,
        performance: {
          hints: false
        },
        devtool: 'eval-source-map'
      }

      config.resolve.alias = {
        ...config.resolve.alias,
        'react-dom': '@hot-loader/react-dom'
      }
    }

    return config
  }

  // Configuration for client-side bundle suitable for running in browsers.
  const clientBundleOutputDir = './wwwroot/dist'
  const clientBundleConfig = merge(sharedConfig(), {
    entry: { 'main-client': './ClientApp/boot-client.jsx' },
    module: {
      rules: [
        {
          test: /\.css$/,
          use: [
            {
              loader: ExtractCssChunks.loader,
              options: {
                hot: true, // if you want HMR - we try to automatically inject hot reloading but if it's not working, add it to the config
                reloadAll: true // when desperation kicks in - this is a brute force HMR flag
              }
            },
            {
              loader: 'css-loader'
            },
            // `postcss-loader`,
            'sass-loader'
          ]
        },
        { test: /\.(scss|sass)$/, use: isDevBuild ? ['css-loader', 'sass-loader'] : [ExtractCssChunks.loader, 'css-loader', 'sass-loader'] },
        {
          test: /\.less$/,
          use: [
            'style-loader',
            {
              loader: 'css-loader'
            },
            {
              loader: 'less-loader',
              options:
              {
                javascriptEnabled: true
              }
            }
          ]
        }
      ]
    },
    output: { path: path.join(__dirname, clientBundleOutputDir) },
    // Some libraries import Node modules but don't use them in the browser.
    // Tell Webpack to provide empty mocks for them so importing them works.
    node: {
      dgram: 'empty',
      fs: 'empty',
      net: 'empty',
      tls: 'empty',
      child_process: 'empty'
    },
    plugins: [
      new webpack.DllReferencePlugin({
        context: __dirname,
        manifest: require('./wwwroot/dist/vendor-manifest.json')
      })
    ].concat(isDevBuild ? [
      // Development.
      new webpack.SourceMapDevToolPlugin({
        filename: '[file].map', // Remove this line if you prefer inline source maps.
        moduleFilenameTemplate: path.relative(clientBundleOutputDir, '[resourcePath]') // Point sourcemap entries to the original file locations on disk
      }),
      new WriteFilePlugin(),
      new ExtractCssChunks({
        filename: 'site.css',
        orderWarning: false
      }),
      new webpack.DefinePlugin({
        'typeof window': '"object"'
      }),
      new webpack.HotModuleReplacementPlugin(),
      new webpack.NoEmitOnErrorsPlugin(),
      new webpack.DefinePlugin({
        'process.env': {
          NODE_ENV: JSON.stringify('development')
        }
      })
    ] : [
      // Production.
      new ExtractCssChunks({
        filename: 'site.css',
        orderWarning: false
      })
    ])
  })

  // Configuration for server-side (prerendering) bundle suitable for running in Node.
  const serverBundleConfig = merge(sharedConfig(), {
    module: {
      rules: [
        { test: /\.css$/,
          use: isDevBuild ? [
            {
              loader: 'css-loader',
              options: {
                modules: true
              }
            }] : [ExtractCssChunks.loader, 'css-loader'] },
        { test: /\.(scss|sass)$/, use: isDevBuild ? ['css-loader', 'sass-loader'] : [ExtractCssChunks.loader, 'css-loader', 'sass-loader'] },
        {
          test: /\.less$/,
          use: isDevBuild ? ['css-loader', {
            loader: 'less-loader',
            options: {
              javascriptEnabled: true
            }
          }] : [ ExtractCssChunks.loader, 'css-loader', {
            loader: 'less-loader',
            options: {
              javascriptEnabled: true,
              root: path.resolve(__dirname, 'ClientApp')
            }
          }]
        }
      ]
    },
    resolve: { mainFields: ['main'] },
    entry: { 'main-server': './ClientApp/boot-server.jsx' },
    plugins: [
      new webpack.DllReferencePlugin({
        context: __dirname,
        manifest: require('./ClientApp/dist/vendor-manifest.json'),
        sourceType: 'commonjs2',
        name: './vendor'
      }),
      new ExtractCssChunks({
        filename: 'site.css',
        orderWarning: false
      })
    ],
    output: {
      libraryTarget: 'commonjs',
      path: path.join(__dirname, './ClientApp/dist')
    },
    target: 'node'
  })

  return [clientBundleConfig, serverBundleConfig]
}
