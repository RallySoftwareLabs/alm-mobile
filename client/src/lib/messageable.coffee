Backbone = require 'backbone'
bus = require 'message_bus'

Messageable =
  publishEvent: (type, args...) ->
    bus.trigger type, args...

  subscribeEvent: (type, handler) ->
    @listenTo bus, type, handler

  subscribeEventOnce: (type, handler) ->
    @listenToOnce bus, type, handler

  unsubscribeEvent: (type, handler) ->
    @stopListening bus, type, handler

  unsubscribeAllEvents: ->
    @stopListening bus

_.extend Messageable, Backbone.Events

module.exports = Messageable