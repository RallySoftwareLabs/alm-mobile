AlmClient = require '../alm/client'
config = require '../config'

setCookie = (res, name, value, expiration) ->
  res.cookie(name, value, {domain: config.cookieDomain, httpOnly: true, secure: true, expires: expiration})

clearCookie = (res, name) ->
  res.clearCookie(name, {domain: config.cookieDomain})

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

  logout: (req, res) ->
    req.session = null
    clearCookie(res, 'JSESSIONID')

    res.json result: "SUCCESS"

  getSessionInfo: (req, res) ->
    jsessionid = req.session.jsessionid
    res.json
      jsessionid: req.session.jsessionid
      securityToken: req.session.securityToken
