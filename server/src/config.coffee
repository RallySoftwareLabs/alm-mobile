
class ServerConfig
  almWebServiceBaseUrl: process.env.ALM_MOBILE_ALM_WS_BASE_URL || "http://abcd.rallydev.com:7001/slm"
  cookieDomain: process.env.ALM_MOBILE_COOKIE_DOMAIN || '.f4tech.com'

  toJSON: ->
    almWebServiceBaseUrl: @almWebServiceBaseUrl

console.log "ALM @#{ServerConfig::almWebServiceBaseUrl}"
console.log "Setting cookie domain as #{ServerConfig::cookieDomain}"

module.exports = new ServerConfig()