ZuulClient = require '../zuulclient/client'

exports.login = (req, res) ->
	username = req.body.username
	password = req.body.password
	client = new ZuulClient()
	client.authenticate username, password, (authenticateResult) ->
		if authenticateResult.isAuthenticated()
			res.cookie('ZSESSIONID', authenticateResult.getAuthKey().getId(), { httpOnly: false})
			res.end('{"result": "SUCCESS"}')
		else
			res.status 401
			res.end('{"result": "FAILURE"}')