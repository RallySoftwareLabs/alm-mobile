express = require('express')
path = require('path')
http = require('http')

module.exports = app = express()

app.configure ->
  app.set('port', process.env.PORT || 3000)
  app.use(express.logger('dev'))  #'default', 'short', 'tiny', 'dev'
  app.use(express.bodyParser())
  app.use(express.cookieParser())
  app.use(express.static(path.join(__dirname, '..', '..', '..', '..', 'client', 'dist')))
  app.use(app.router)

  app.set('views', path.join(__dirname, '..', '..', '..', '..', 'client', 'dist'))
  app.set('view engine', 'html')
  app.engine('html', require('ejs').renderFile)

app.configure 'development', ->
  app.use express.errorHandler { dumpExceptions: true, showStack: true }

app.configure 'production', ->
  app.use express.errorHandler()

app.get '*', (req, res) -> res.render 'index.html'

http.createServer(app).listen app.get('port'), ->
  console.log("Express server listening on port #{app.get('port')}")
