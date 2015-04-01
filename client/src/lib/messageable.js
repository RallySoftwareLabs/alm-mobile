var Backbone = require('backbone');
var bus = require('message_bus');
var _ = require('lodash');

var Messageable = {
  publishEvent: function() {
    bus.trigger.apply(bus, arguments);
  },

  subscribeEvent: function(type, handler) {
    this.listenTo(bus, type, handler);
  },

  subscribeEventOnce: function(type, handler) {
    this.listenToOnce(bus, type, handler);
  },

  unsubscribeEvent: function(type, handler) {
    this.stopListening(bus, type, handler);
  },

  unsubscribeAllEvents: function() {
    this.stopListening(bus);
  }
};

_.extend(Messageable, Backbone.Events);

module.exports = Messageable;
