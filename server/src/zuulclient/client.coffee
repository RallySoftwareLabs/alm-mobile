request = require "request"
ZuulAuthentication = require "./zuul_authentication"

module.exports = class ZuulClient
  constructor: ->

  authenticate: (username, password, callback) ->
    request(
      uri: "http://mparrish_15mbp.zuul1.f4tech.com:3000/key.js"
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
