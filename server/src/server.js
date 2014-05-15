var express = require('express');
var cookieParser = require('cookie-parser');
var session = require('express-session');
var path = require('path');
var http = require('http');
var oauth = require('./oauth');

module.exports = app = express();

app.set('port', process.env.PORT || 3000);
app.set('views', path.join(__dirname, '..', '..', 'client', 'dist'));

app.use(express.static(path.join(__dirname, '..', '..', 'client', 'dist')));
app.use(cookieParser());
app.use(session({ key: 'alm-mobile', secret: 'super-secret!'}));

oauth.initializeRoutes(app);

http.createServer(app).listen(app.get('port'), function() {
  console.log("Express server listening on port " + app.get('port'));
});
