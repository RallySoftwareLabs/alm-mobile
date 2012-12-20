request = require "request"
ZuulAuthentication = require "./zuul_authentication"
config = require "../config"

module.exports = class ZuulClient
  constructor: ->

  authenticate: (username, password, callback) ->
    console.log 'authenticating zuul'
    request(
      uri: "#{config.zuulBaseUrl}/key.js"
      method: "PUT"
      body: JSON.stringify(
        username: username
        password: password
      )
    , (error, response, body) ->
      console.log error, response?.statusCode, body
      authenticateResult = new ZuulAuthentication(response)
      callback?(authenticateResult)
    )
