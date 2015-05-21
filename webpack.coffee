webpack = require 'webpack'
path    = require 'path'

configuration = require './server/configuration'

# с i18n plugin непонятно: видимо, нет возможности переключать язык на лету, 
# поэтому, видимо, придётся писать своё решение

# I18nPlugin = require 'i18n-webpack-plugin'

# languages =
#   ru_RU: require('./sources/client/translation/ru_RU.json')
#   en_US: null

# module.exports = Object.keys(languages).map (language) ->

HtmlWebpackPlugin = require 'html-webpack-plugin'

module.exports =
	# for bower
	# resolve:
	# 	root: [path.join(__dirname, "bower_components")]

	# name: language

	entry:
		# массив из трёх строк требуется для react-hot-loader
		application : [
			"webpack-dev-server/client?http://0.0.0.0:#{configuration.development.webpack.development_server.port}",
			'webpack/hot/only-dev-server',
			'./client/application.react'
		]

	output: 
		path: path.resolve(__dirname, 'build', 'client')
		publicPath: '/'
		# publicPath: 'http://mycdn.com/'
		# filename: "[name].#{language}.js"
		filename: "[name].[hash].js"
		# filename: 'bundle.js'
    # chunkFilename: "[id].bundle.js"
		sourceMapFilename: '[file].map'

	module:
		loaders: [
			{ 
				test: /\.css$/
				loaders: ['style', 'css'] 
			},
			{ 
				test: /\.coffee$/
				loader: 'coffee' 
			},
			{ 
				test: /\.react$/
				loaders: ['react-hot', 'coffee', 'cjsx'] # 'jsx?harmony'
			},
			{ 
				test: /\.react.page$/
				loaders: ['react-router-proxy', 'react-hot', 'coffee', 'cjsx'] # 'jsx?harmony'
			},
			{ 
				test: /\.less$/
				loaders: ['style', 'css', 'less'] 
			},
			{ 
				test: /\.(png|jpg)$/
				loader: 'url?limit=8192' # inline base64 URLs for <=8k images, direct URLs for the rest
			},
			{
				test: /\.(png|woff|woff2|eot|ttf|svg)$/
				loader: 'url-loader?limit=100000' # Any png-image or woff-font below or equal to 100K will be converted to inline base64 instead
			}
		]

	resolve:
		# you can now require('file') instead of require('file.coffee')
		extensions: ['', '.js', '.json', '.coffee', '.react', '.less']
		modulesDirectories: ['build', 'libraries', 'bower_components', 'node_modules']

	plugins: [
		new webpack.optimize.CommonsChunkPlugin('common', 'common.[hash].js')
		new webpack.optimize.OccurenceOrderPlugin(yes)
		new HtmlWebpackPlugin(template: './client/index.html')
		# new I18nPlugin(languages[language])

    new webpack.HotModuleReplacementPlugin()

		# for bower
		# new webpack.ResolverPlugin(
		# 	new webpack.ResolverPlugin.DirectoryDescriptionFilePlugin("bower.json", ["main"])
		# )
	]