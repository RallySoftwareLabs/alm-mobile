define ->

  bus = require 'message_bus'

  Messageable =
    publishEvent: (type, args...) ->
      bus.publish type, args...

    subscribeEvent: (type, handler) ->
      bus.subscribe type, handler, this

    unsubscribeEvent: (type, handler) ->
      bus.unsubscribe type, handler, this

    unsubscribeAllEvents: ->
      bus.unsubscribe null, null, this