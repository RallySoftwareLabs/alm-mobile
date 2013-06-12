request = require "request"
config = require "../config"
_ = require 'lodash'

module.exports = class AlmClient

  ###
  # @param {Object} options
  # @param {String} options.username
  # @param {String} options.password
  ###
  authorize: (options, cb) ->
    requestConfig =
      uri: "#{config.almWebServiceBaseUrl}/webservice/v2.x/security/authorize"
      method: 'GET'
      jar: false
      strictSSL: false

    console.log "Getting AuthToken from #{requestConfig.uri}"

    if options.username? && options.password?
      base64Auth = new Buffer("#{options.username}:#{options.password}").toString('base64')
      requestConfig.auth = "#{options.username}:#{options.password}"
    else
      return cb('You must pass both username and password to get a security token')

    # Get CSRF Token
    request(requestConfig, (err, authResponse, body) ->
      console.log err, response?.statusCode, body
      unless err
        # console.log body
        try
          securityToken = JSON.parse(body).OperationResult.SecurityToken
          jsessionid = null

          cookieHeader = authResponse.headers["set-cookie"]
          console.log cookieHeader
          if cookieHeader
            cookies = _.reduce(cookieHeader, (acc, cookie) ->
              cookieKeyValue = _.first(cookie.split(';')).split('=')
              acc[cookieKeyValue[0].toLowerCase()] = cookieKeyValue[1]
              acc
            , {})

            jsessionid = cookies.jsessionid
            console.log "Cookies: ", cookies, "jsessionid", jsessionid
        catch e
          err = "Unable to parse JSON from: J: #{options.jsessionid}, Body: #{body}"
          console.log err
      
      cb?(err, jsessionid, securityToken)
    )

  @isSecure: -> config.almWebServiceBaseUrl.indexOf('https') > -1

