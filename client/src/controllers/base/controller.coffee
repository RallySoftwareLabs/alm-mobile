define ->
  Chaplin = require 'chaplin'
  app = require 'application'

  class Controller extends Chaplin.Controller
      
    afterProjectLoaded: (callback) ->
      if app.session.project?
        callback?.apply this
      else
        @subscribeEvent 'projectready', @onProjectReady(callback)

    onProjectReady: (callback) ->
      => 
        @unsubscribeEvent 'projectready', @onProjectReady
        callback?.apply this
