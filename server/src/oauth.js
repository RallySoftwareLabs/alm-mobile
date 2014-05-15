var uuid = require('node-uuid');
var qs = require('querystring');
var request = require('request');
var config = require('../../config.json').config;

// You can get your Client ID and Secret from
// https://login.rally1.rallydev.com/client.html
// The SERVER_URL must match the one specifed in Rally
var CLIENT_ID  = process.env.CLIENT_ID || config.oauth.CLIENT_ID;
var CLIENT_SECRET = process.env.CLIENT_SECRET || config.oauth.CLIENT_SECRET;
var SERVER_URL = process.env.SERVER_URL || config.oauth.SERVER_URL;

// The Rally OAuth Server
var OAUTH_SERVER = process.env.OAUTH_SERVER || config.oauth.OAUTH_SERVER;

// Redirect to the auth URL to grant access
var RALLY_AUTH_URL = OAUTH_SERVER + "/auth";

// Exchange the supplied code for an access token
var RALLY_TOKEN_URL = OAUTH_SERVER + "/token";

module.exports = {
  initializeRoutes: function(app) {

    app.get('/login', function(req, res) {
      var uuidString = uuid.v4();
      var params = {
        state: uuidString,
        response_type: 'code',
        redirect_uri: SERVER_URL + "/oauth-redirect",
        client_id: CLIENT_ID,
        scope: 'openid'
      };
      req.session.state = uuidString;
      req.session.auth = null;

      res.redirect(RALLY_AUTH_URL + '?' + qs.stringify(params));
    });

    app.get('/oauth-redirect', function(req, res) {
      if (req.query.state != req.session.state) {
        return res.send(500, { error: 'Invalid State' });
      } else if (req.query.error) {
        return res.send(500, { error: 'Error with authorization: ' + req.query.error });
      }

      var newParams = {
        code: req.query.code,
        redirect_uri: SERVER_URL + '/oauth-redirect',
        grant_type: 'authorization_code',
        client_id: CLIENT_ID,
        client_secret: CLIENT_SECRET
      };

      request.post(RALLY_TOKEN_URL, { form: newParams }, function(err, r, body) {
        if (err || r.statusCode !== 200) {
          return res.send(500, 'Failed to get token: ' + r.statusCode);
        }

        try {
          req.session.auth = JSON.parse(body).access_token;
        } catch (jsone) {
          return res.send(500, 'Unable to parse JSON response: ' + jsone + ': ' + body);
        }
        req.session.state = null;
        res.redirect('/');
      });
    });

    app.get('/logout', function(req, res) {
      req.session.destroy();
      res.redirect('/login');
    });

    app.get('*', function(req, res) {
      if (!req.session.auth) {
        return res.redirect('/login');
      }
      console.log(req.session.auth);

      return res.render('index.html');
    });
  }
};