
class Auth
  @isUserLoggedIn: (req, res, next) ->
    return res.send 401 if !req.session.jsessionid
    next()

module.exports = Auth