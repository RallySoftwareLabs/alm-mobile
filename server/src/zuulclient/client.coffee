request = require("request")

class ZuulClient
    constructor: ->

    login: (username, password, callback) ->
        request(
            uri: "http://mparrish_15mbp.zuul1.f4tech.com:3000/key.js"
            method: "PUT"
            body: JSON.stringify(
                username: username
                password: password
            )
        , (error, response, body) ->
            console.log response.statusCode, body
            authenticateResult = response.statusCode is 200 and JSON.parse(body)
            callback?(authenticateResult)
        )
exports.Client = ZuulClient