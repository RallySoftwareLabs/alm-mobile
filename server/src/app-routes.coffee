index = require './routes/index'

module.exports = (app) ->
  app.get '/:id?', index
  app.get '/userstory/:id', index
  app.get '/task/:id', index
  app.get '/defect/:id', index
  app.get '/userstory/:id/discussion', index
  app.get '/task/:id/discussion', index
  app.get '/defect/:id/discussion', index
  app.get '/new/:type', index