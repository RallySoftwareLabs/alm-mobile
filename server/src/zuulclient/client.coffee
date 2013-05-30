request = require "request"
ZuulAuthentication = require "./zuul_authentication"
config = require "../config"
_ = require 'lodash'

module.exports = class ZuulClient
  constructor: ->

  authenticate: (username, password, callback) =>
    authenticateResult = new ZuulAuthentication()

    @_authenticateZuul username, password, (err, zuulResponse) =>
      if zuulResponse
        @_authorizeALM username, password, zuulResponse.authKey, (err, jsessionid, securityToken) ->
          unless err
            authenticateResult.set zuulResponse, jsessionid, securityToken

          callback?(authenticateResult)
      else
        callback?(authenticateResult)

  _authenticateZuul: (username, password, cb) ->
    console.log 'authenticating zuul'
    request(
      uri: "#{config.zuulBaseUrl}/key.js"
      method: "PUT"
      body: JSON.stringify(username: username, password: password)
    , (err, response, body) ->
      # console.log err, response?.statusCode, body

      authenticated = response?.statusCode is 200
      zuulResponse = authenticated and JSON.parse(response.body)

      cb?(err, zuulResponse)
    )

  _authorizeALM: (username, password, zsessionid, cb) ->
    base64Auth = new Buffer("#{username}:#{password}").toString('base64')
    # Get CSRF Token
    request(
      uri: "#{config.almWebServiceBaseUrl}/webservice/v2.x/security/authorize"
      method: 'GET'
      auth: "#{username}:#{password}"
      headers:
        ZSESSIONID: zsessionid
    , (err, authResponse, body) ->
      unless err
        # console.log body
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
          # console.log "Cookies: ", cookies, "jsessionid", jsessionid
      
      cb?(err, jsessionid, securityToken)
    )
