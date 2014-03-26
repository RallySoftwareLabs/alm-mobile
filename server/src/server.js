var express = require('express');
var path = require('path');
var http = require('http');

module.exports = app = express();

app.configure(function() {
  app.set('port', process.env.PORT || 3000);
  app.use(express.logger('dev'));  //'default', 'short', 'tiny', 'dev'
  app.use(express.compress());
  app.use(express.bodyParser());
  app.use(express.static(path.join(__dirname, '..', '..', 'client', 'dist')));
  app.use(app.router);

  app.set('views', path.join(__dirname, '..', '..', 'client', 'dist'));
  app.set('view engine', 'html');
  app.engine('html', require('ejs').renderFile);
});
app.configure('development', function() {
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});
app.configure('production', function() {
  app.use(express.errorHandler());
});
app.get('*', function(req, res) { return res.render('index.html'); });

http.createServer(app).listen(app.get('port'), function() {
  console.log("Express server listening on port " + app.get('port'));
});
