
almWebServiceBaseUrl = process.env.ALM_MOBILE_ALM_WS_BASE_URL || "http://abcd.rallydev.com:7001/slm"
class ServerConfig
  almWebServiceBaseUrl: almWebServiceBaseUrl
  zuulBaseUrl: process.env.ALM_MOBILE_ZUUL_BASE_URL || "http://abcd.zuul1.f4tech.com:3000"

  toJSON: ->
    return {
      almWebServiceBaseUrl: @almWebServiceBaseUrl
      zuulBaseUrl: @zuulBaseUrl
    }

  console.log "ALM @#{almWebServiceBaseUrl}"

module.exports = new ServerConfig()