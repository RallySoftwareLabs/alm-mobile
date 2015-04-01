var version = require('./package.json').version;
var path = require('path');
var webpack = require('webpack');
var grunt = require('grunt');
var _ = require('lodash');

module.exports = {
    context: __dirname,
    entry: _.union(['./client/src/application.coffee', './client/src/initialize.coffee'],
                    grunt.file.expand({filter: 'isFile'}, './client/src/controllers/**/*.js'),
                    grunt.file.expand({filter: 'isFile'}, './client/src/controllers/**/*.coffee')),
    output: {
        path: './client/gen/js/src/',
        filename: 'app.js',
        publicPath: '/dist/'
    },
    externals: {
        backbone: 'Backbone',
        fluxxor: 'Fluxxor',
        jquery: 'jQuery',
        lodash: '_',
        underscore: '_',
        react: 'React',
        moment: true,
        pagedown: 'Markdown',
        spin: 'Spinner',
        'reconnecting-websocket': 'ReconnectingWebSocket',
        rallymetrics: 'RallyMetrics',
        'html-md': 'md'
    },

    debug: true,
    devtool: '#inline-source-map',

    resolve: {
        modulesDirectories: [".", "node_modules"],
        extensions: ["", ".webpack.js", ".web.js", ".js", ".coffee", ".jsx"]
    },

    resolveLoader: {
        root: path.join(__dirname, "node_modules")
    },

    plugins: [
        new webpack.optimize.DedupePlugin(),
        new webpack.optimize.OccurenceOrderPlugin(true),
        new webpack.optimize.AggressiveMergingPlugin()
    ],

    module: {
        preLoaders: [
            {
                test: /\.js$/,
                loader: "source-map-loader"
            }
        ],
        loaders: [
            {
                test: /\.jsx$/,
                loader: 'jsx-loader?harmony'
            },
            {
                test: /\.coffee$/,
                loader: 'coffee-loader'
            },
            {
                test: /\.less$/,
                loader: "style!css!less"
            },
            {
                test: /\.css$/,
                loader: 'style!css'
            },
            {
                test: /\.gif/,
                loader: 'urllimit=10000&minetype=image/gif'
            },
            {
                test: /\.jpg/,
                loader: 'url?limit=10000&minetype=image/jpg'
            },
            {
                test: /\.png/,
                loader: 'url?limit=10000&minetype=image/png'
            },
            {
                test: /\.woff$/,
                loader: "url?limit=10000&minetype=application/font-woff"
            },
            {
                test: /\.ttf$/,
                loader: "file"
            },
            {
                test: /\.eot$/,
                loader: "file"
            },
            {
                test: /\.svg$/,
                loader: "file"
            }
        ]
    }
};