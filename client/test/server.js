var express = require('express');
var path = require('path');

var app = express();

app.get('/testpage.html', function(req, res) {
    res.sendfile(path.resolve(__dirname) + '/testpage.html');
});

module.exports = app;
