React = require 'react'
Promise = require('es6-promise').Promise
app = require 'application'
appConfig = require 'app_config'
Messageable = require 'lib/messageable'
realtimeUpdater = require 'lib/realtime_updater'
Projects = require 'collections/projects'
LoadingIndicatorView = require 'views/loading_indicator'

module.exports = class Controller

  _.extend @prototype, Messageable
    
  whenProjectIsLoaded: (options = {}) ->
    new Promise (resolve, reject) =>
      if options.project
        projectRef = "#{appConfig.almWebServiceBaseUrl}/webservice/@@WSAPI_VERSION/project/#{options.project}"

      sessionProject = app.session.get('project')
      if sessionProject?
        if !projectRef || _.contains(sessionProject.get('_ref'), projectRef)
          resolve()
        else
          @_renderLoadingIndicatorUntilProjectIsReady(options.showLoadingIndicator).then ->
            debugger;
            resolve()
          debugger;
          Projects.fetchAll().then (projects) =>
            project = projects.find _.isAttributeEqual '_ref', projectRef
            app.session.set 'project', project
      else
        @_renderLoadingIndicatorUntilProjectIsReady(options.showLoadingIndicator).then ->
          resolve()
        app.session.initSessionForUser(projectRef)

  listenForRealtimeUpdates: (options, callback, scope) ->
    @websocket = realtimeUpdater.listenForRealtimeUpdates(options, callback, scope)

  _renderLoadingIndicatorUntilProjectIsReady: (showLoadingIndicator) ->
    new Promise (resolve, reject) =>
      if showLoadingIndicator != false
        @renderReactComponent LoadingIndicatorView, region: 'main', text: 'Initializing'
      @subscribeEventOnce 'projectready', -> resolve()

  updateTitle: (title) ->
    @publishEvent "updatetitle", title

  redirectTo: (path, options) ->
    @publishEvent "router:route", path, options

  markFinished: ->
    @trigger 'controllerfinished', this

  updateUrl: (newUrl) ->
    @publishEvent "router:changeURL", newUrl

  renderReactComponent: (componentClass, props = {}, id) ->
    component = componentClass(_.omit(props, 'region'))

    React.render component, (if id then document.getElementById(id) else document.body)

  dispose: ->
    @stopListening()
    @unsubscribeAllEvents()
    @websocket?.close()
    @websocket = null
