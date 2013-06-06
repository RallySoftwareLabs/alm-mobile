define [
	'chaplin'
	'application'
], (Chaplin, app) ->
# Navigation = require 'models/navigation'
# NavigationView = require 'views/navigation-view'

  class Controller extends Chaplin.Controller
      
    afterProjectLoaded: (callback) ->
      if app.session.project?
        callback?()
      else
        @subscribeEvent 'projectready', @onProjectReady(callback)

    onProjectReady: (callback) ->
      => 
        @unsubscribeEvent 'projectready', @onProjectReady
        callback?()
