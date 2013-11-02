define ->
  Chaplin = require 'chaplin'
  React = require 'react'
  app = require 'application'
  InitializingView = require 'views/initializing'

  class Controller extends Chaplin.Controller
      
    whenLoggedIn: (callback) ->
      if app.session.get('project')?
        @goToPage callback
      else
        @view = React.renderComponent(InitializingView(), document.getElementById('content'))
        @subscribeEvent 'projectready', @onProjectReady(callback)

    onProjectReady: (callback) ->
      func = => 
        @unsubscribeEvent 'projectready', func
        @view.dispose()
        @goToPage callback

    goToPage: (callback) ->
      if app.session.hasAcceptedLabsNotice()
        callback?.apply this
      else
        setTimeout =>
          @redirectToRoute 'auth#labsNotice'
        , 0

    updateTitle: (title) ->
      @publishEvent "updatetitle", title
