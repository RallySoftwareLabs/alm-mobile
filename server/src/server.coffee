# spdy = require('spdy')
# fs = require('fs')

express = require('express')
path = require('path')
http = require('http')
hbs = require('hbs')
config = require('./config')

module.exports = app = express()

app.configure ->
  app.set('port', process.env.PORT || 3000)
  app.use(express.logger('dev'))  #'default', 'short', 'tiny', 'dev'
  app.use(express.bodyParser())
  app.use(express.cookieParser())
  app.use(express.cookieSession(key: 'mblsessid', secret: 'mblsup3rs3cr3t'))
  app.use(app.router)
  app.use(express.static(path.join(__dirname, '..', '..', '..', '..', 'client', 'dist')))

  # app.set('view options', layout: false)
  app.set('views', __dirname + '/../../../src/views')
  app.set('view engine', 'hbs')
  # app.engine('hbs', hbs.__express)

app.configure 'development', ->
  app.use express.errorHandler { dumpExceptions: true, showStack: true }

app.configure 'production', ->
  app.use express.errorHandler()

require('./api-private-routes')(app)
require('./app-routes')(app)


# options =
#   key: fs.readFileSync(__dirname + '/keys/spdy-key.pem')
#   cert: fs.readFileSync(__dirname + '/keys/spdy-cert.pem')
#   ca: fs.readFileSync(__dirname + '/keys/spdy-csr.pem')

# server = spdy.createServer(options, app)

# server.listen(443)

http.createServer(app).listen app.get('port'), ->
  console.log("Express server listening on port #{app.get('port')}")
