# spdy = require('spdy')
# fs = require('fs')

express = require('express')
path = require('path')
http = require('http')
auth = require('./routes/login')

app = express()

app.configure ->
    app.set('port', process.env.PORT || 3000)
    app.use(express.logger('dev'))  #'default', 'short', 'tiny', 'dev'
    app.use(express.bodyParser())
    app.use(express.static(path.join(__dirname, '../../public')))

# app.get('/wines', wine.findAll)
# app.get('/wines/:id', wine.findById)
# app.post('/wines', wine.addWine)
# app.put('/wines/:id', wine.updateWine)
# app.delete('/wines/:id', wine.deleteWine)

app.post('/login', auth.login)


# options =
#   key: fs.readFileSync(__dirname + '/keys/spdy-key.pem')
#   cert: fs.readFileSync(__dirname + '/keys/spdy-cert.pem')
#   ca: fs.readFileSync(__dirname + '/keys/spdy-csr.pem')

# server = spdy.createServer(options, app)

# server.listen(443)

http.createServer(app).listen app.get('port'), ->
    console.log("Express server listening on port #{app.get('port')}")
