ZuulClient = require '../zuulclient/client'
config = require '../config'

exports.login = (req, res) ->
	username = req.body.username
	password = req.body.password
	rememberMe = req.body.rememberme
	expiration = null
	client = new ZuulClient()
	client.authenticate username, password, (authenticateResult) ->
		if authenticateResult.isAuthenticated()
			if rememberMe is "true"
				expiration = new Date(Date.now())
				expiration.setDate(expiration.getDate() + 14)

			res.cookie('ZSESSIONID', authenticateResult.getAuthKey().getId(), { httpOnly: false, expires: expiration, domain: '.f4tech.com'})
			res.end("{\"result\": \"SUCCESS\", \"username\": \"#{authenticateResult.getName()}\"}")
		else
			res.status 401
			res.end('{"result": "FAILURE"}')