zuulclient = require('../zuulclient/client')

exports.login = (req, res) ->
    username = req.params.username
    password = req.params.password
    console.log "Trying to authenticate #{username}"
    zuulclient = new zuulclient.Client()
    zuulclient.login username, password, (authenticateResult) ->
        if authenticateResult.authKey?
            res.cookie('ZSESSIONID', authenticateResult.authKey._ref, { path: '/', maxAge: null, httpOnly: false})
            res.end('SUCCESS')
        else
            res.end('FAILURE')