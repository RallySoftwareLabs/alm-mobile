AlmClient = require '../alm/client'
config = require '../config'

setCookie = (res, name, value, expiration) ->
  res.cookie(name, value, {domain: config.cookieDomain, httpOnly: false, expires: expiration})

module.exports = 
  login: (req, res) ->
    username = req.body.username
    password = req.body.password
    rememberMe = req.body.rememberme
    expiration = null
    new AlmClient().authorize {username: username, password: password}, (err, jsessionid, securityToken) ->
      if err?
        res.status 401
        res.json result: "FAILURE"

      if rememberMe is "true"
        expiration = new Date(Date.now())
        expiration.setDate(expiration.getDate() + 14)

      if jsessionid
        setCookie(res, 'JSESSIONID', jsessionid, expiration)
        req.session.jsessionid = jsessionid
      
      req.session.securityToken = securityToken

      res.json
        result: "SUCCESS"
        securityToken: securityToken
        jsessionid: jsessionid

  getSessionInfo: (req, res) ->
    jsessionid = req.session.jsessionid
    res.json
      jsessionid: req.session.jsessionid
      securityToken: req.session.securityToken
