config = require '../config'

module.exports = (req, res) ->
	res.render('index', config: JSON.stringify(config.toJSON()))
