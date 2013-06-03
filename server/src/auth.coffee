
class Auth
  @isUserLoggedIn: (req, res, next) ->
    return res.send 401 if !req.session._id
    next()

module.exports = Auth