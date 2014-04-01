appConfig = JSON.parse('@@config')
appConfig.isProd = ->
  appConfig.almWebServiceBaseUrl == "https://rally1.rallydev.com/slm"

module.exports = appConfig
