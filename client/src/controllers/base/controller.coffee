app = require 'application'
appConfig = require 'app_config'
Messageable = require 'lib/messageable'
realtimeUpdater = require 'lib/realtime_updater'
Projects = require 'collections/projects'
LoadingIndicatorView = require 'views/loading_indicator'

module.exports = class Controller

  _.extend @prototype, Messageable
    
  whenProjectIsLoaded: (options) ->
    if _.isFunction(options)
      callback = options
    else
      callback = options.fn
      projectRef = "#{appConfig.almWebServiceBaseUrl}/webservice/@@WSAPI_VERSION/project/#{options.project}"

    sessionProject = app.session.get('project')
    if sessionProject?
      if !projectRef || _.contains(sessionProject.get('_ref'), projectRef)
        callback?.apply this
      else
        project = Projects::projects.find _.isAttributeEqual '_ref', projectRef
        @_renderLoadingIndicatorUntilProjectIsReady(callback, options.showLoadingIndicator)
        app.session.set 'project', project
    else
      @_renderLoadingIndicatorUntilProjectIsReady(callback, options.showLoadingIndicator)
      app.session.initSessionForUser(projectRef)

  listenForRealtimeUpdates: (options, callback, scope) ->
    @websocket = realtimeUpdater.listenForRealtimeUpdates(options, callback, scope)

  _onProjectReady: (callback) ->
    func = =>
      callback?.apply this

  _renderLoadingIndicatorUntilProjectIsReady: (callback, showLoadingIndicator) ->
    if showLoadingIndicator != false
      @renderReactComponent LoadingIndicatorView, region: 'main', text: 'Initializing'
    @subscribeEventOnce 'projectready', @_onProjectReady(callback)

  updateTitle: (title) ->
    @publishEvent "updatetitle", title

  redirectTo: (path, options) ->
    @publishEvent "router:route", path, options

  markFinished: ->
    @trigger 'controllerfinished', this

  renderReactComponent: (componentClass, props = {}, id) ->
    component = componentClass(_.omit(props, 'region'))

    React.renderComponent component, (if id then document.getElementById(id) else document.body)

  dispose: ->
    @stopListening()
    @unsubscribeAllEvents()
    @websocket?.close()
    @websocket = null
