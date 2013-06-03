request = require "request"
ZuulAuthentication = require "./zuul_authentication"
config = require "../config"
AlmClient = require "../alm/client"

module.exports = class ZuulClient
  constructor: ->

  authenticate: (username, password, callback) =>
    authenticateResult = new ZuulAuthentication()

    @_authenticateZuul username, password, (err, zuulResponse) =>
      if zuulResponse
        new AlmClient().authorize {username: username, password: password}, zuulResponse.authKey, (err, jsessionid, securityToken) ->
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
