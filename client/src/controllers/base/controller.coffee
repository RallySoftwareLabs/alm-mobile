define ->
  Chaplin = require 'chaplin'
  app = require 'application'

  class Controller extends Chaplin.Controller
      
    afterProjectLoaded: (callback) ->
      if app.session.get('project')?
        callback?.apply this
      else
        @subscribeEvent 'projectready', @onProjectReady(callback)

    onProjectReady: (callback) ->
      func = => 
        @unsubscribeEvent 'projectready', func
        callback?.apply this
