define ->
  Backbone = require 'backbone'

  bus = {}

  bus.subscribe   = Backbone.Events.on
  bus.unsubscribe = Backbone.Events.off
  bus.publish     = Backbone.Events.trigger

  bus