
class ServerConfig
  almWebServiceBaseUrl: process.env.ALM_MOBILE_ALM_WS_BASE_URL || "http://abcd.rallydev.com:7001/slm"
  zuulBaseUrl: process.env.ALM_MOBILE_ZUUL_BASE_URL || "http://abcd.zuul1.f4tech.com:3000"

  toJSON: ->
    return {
      almWebServiceBaseUrl: @almWebServiceBaseUrl
      zuulBaseUrl: @zuulBaseUrl
    }

module.exports = new ServerConfig()