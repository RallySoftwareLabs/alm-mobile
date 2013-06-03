Auth = require './auth'
LoginRoutes = require './routes/login'
index = require './routes/index'

module.exports = (app) ->
  app.get '/',
    index
  
  app.post '/login',
    LoginRoutes.login
  
  app.get '/isLoggedIn', (req, res) ->
    res.json { loggedIn: !!req.session.zsessionid }

  app.get '/getSessionInfo',
    Auth.isUserLoggedIn
    LoginRoutes.getSessionInfo
