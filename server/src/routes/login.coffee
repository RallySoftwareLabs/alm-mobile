ZuulClient = require '../zuul/client'
AlmClient = require '../alm/client'
config = require '../config'

setCookie = (res, name, value, expiration) ->
	res.cookie(name, value, {domain: '.rallydev.com', httpOnly: false, expires: expiration})

module.exports = 
	login: (req, res) ->
		username = req.body.username
		password = req.body.password
		rememberMe = req.body.rememberme
		expiration = null
		zuulClient = new ZuulClient()
		zuulClient.authenticate username, password, (authenticateResult) ->
			if authenticateResult.isAuthenticated()
				if rememberMe is "true"
					expiration = new Date(Date.now())
					expiration.setDate(expiration.getDate() + 14)

				zsessionid = authenticateResult.getAuthKey().getId()
				setCookie(res, 'ZSESSIONID', zsessionid, expiration)
				req.session.zsessionid = zsessionid

				jsessionid = authenticateResult.getJSessionID()
				if jsessionid
					setCookie(res, 'JSESSIONID', jsessionid, expiration)
					req.session.jsessionid = authenticateResult.getJSessionID()
				
				securityToken = authenticateResult.getSecurityToken()
				req.session.securityToken = securityToken

				req.session._id = zsessionid

				res.json
					result: "SUCCESS"
					username: authenticateResult.getName()
					securityToken: securityToken
			else
				res.status 401
				res.json result: "FAILURE"

	getSessionInfo: (req, res) ->
		jsessionid = req.session.jsessionid
		zsessionid = req.session.zsessionid
		res.json jsessionid: req.session.jsessionid, zsessionid: req.session.zsessionid, securityToken: req.session.securityToken
		# client = new AlmClient()
		# client.authorize {jsessionid: jsessionid}, zsessionid, (err, jsessionid, securityToken) ->
		# 	return res.send 401 if err

		# 	# expiration = new Date(Date.now())
		# 	# expiration.setDate(expiration.getDate() + 14)
		# 	setCookie(res, 'JSESSIONID', jsessionid, null)
		# 	req.session.securityToken = securityToken
		# 	res.json result: 'SUCCESS', securityToken: securityToken
