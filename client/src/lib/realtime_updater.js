var ReconnectingWebSocket = require('reconnecting-websocket');
var Messageable = require('lib/messageable');
var Projects = require('collections/projects');

var websocket;

module.exports = {

  listenForRealtimeUpdates: function(options) {
    var me = this;
    var project = options.project;

    this.stopListeningForRealtimeUpdates();
    websocket = new ReconnectingWebSocket('wss://realtime.rally1.rallydev.com/_websocket');
    
    websocket.onopen = function() {
      Projects.getIdsWithinScopeDown(project).then(function(projectsToSubscribeTo) {
        _.each(projectsToSubscribeTo, function(projectUuid) {
          websocket.send(JSON.stringify({
            "uri": "/_subscribe",
            "request-method": "post",
            "body": { "topic": projectUuid }
          }));
        });
      });
    };

    websocket.onmessage = function(msg) {
      var msgData = JSON.parse(msg.data).data;
      if (!msgData) {
        return;
      }
      Messageable.publishEvent('realtimeMessage', me._translateMessage(msgData));
    };

    return websocket;
  },

  stopListeningForRealtimeUpdates: function() {
    if (websocket) {
      websocket.close();
      websocket = null;
    }
  },

  _translateMessage: function(msg) {
    var newMsg = _.transform(msg, function(newObj, value, key) {
      if (_.contains(['id', 'transaction', 'action'], key)) {
        newObj[key] = value;
      } else if (_.contains(['changes', 'state'], key)) {
        newObj[key] = this._convertStateObj(value);
      }
    }, {}, this);

    newMsg.modelType = newMsg.state.object_type;
    return newMsg;
  },

  _convertStateObj: function(state) {
    return _.transform(state, function(newObj, value, key) {
      newObj[value.name] = value.value;
    });
  }
};
