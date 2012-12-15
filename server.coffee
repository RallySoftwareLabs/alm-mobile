# spdy = require('spdy')
# fs = require('fs')

express = require('express')
path = require('path')
http = require('http')
auth = require('./server/src/routes/login')
config = require('./server/src/config')

module.exports = app = express()

app.configure ->
  app.set('port', process.env.PORT || 3000)
  app.use(express.logger('dev'))  #'default', 'short', 'tiny', 'dev'
  app.use(express.bodyParser())
  app.use(express.static(path.join(__dirname, 'public')))

app.configure 'development', ->
  app.use express.errorHandler { dumpExceptions: true, showStack: true }

app.configure 'production', ->
  app.use express.errorHandler()

app.post('/login', auth.login)


# options =
#   key: fs.readFileSync(__dirname + '/keys/spdy-key.pem')
#   cert: fs.readFileSync(__dirname + '/keys/spdy-cert.pem')
#   ca: fs.readFileSync(__dirname + '/keys/spdy-csr.pem')

# server = spdy.createServer(options, app)

# server.listen(443)

app.startServer = ->
  http.createServer(app).listen app.get('port'), ->
    console.log("Express server listening on port #{app.get('port')}")
