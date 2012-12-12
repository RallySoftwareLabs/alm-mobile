zuulclient = require('../zuulclient/client')

exports.login = (req, res) ->
	username = req.body.username
	password = req.body.password
	console.log "Trying to authenticate #{username}"
	client = new zuulclient()
	client.login username, password, (authenticateResult) ->
		if authenticateResult.authKey?
			console.log "Setting cookie to #{authenticateResult.authKey._ref}"
			res.cookie('ZSESSIONID', authenticateResult.authKey._ref, { httpOnly: false})
			res.end('{"result": "SUCCESS"}')
		else
			res.status 401
			res.end('{"result": "FAILURE"}')