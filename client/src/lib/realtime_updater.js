var ReconnectingWebSocket = require('reconnecting-websocket');
var Projects = require('collections/projects');

module.exports = {

  listenForRealtimeUpdates: function(options, callback, scope) {
    var project = options.project;

    var websocket = new ReconnectingWebSocket('wss://realtime.rally1.rallydev.com/_websocket');
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
      var me = this;
      var msgData = JSON.parse(msg.data).data;
      if (!msgData) {
        return;
      }
      callback.call(scope, me._translateMessage(msgData));
    };

    return websocket;
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
