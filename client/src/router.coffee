_ = require 'underscore'
Backbone = require 'backbone'
Messageable = require 'lib/messageable'
MetricsHandler = require 'lib/metrics_handler'
appConfig = require 'app_config'

controllerSuffix = '_controller'
routes = {}
routeDefs = []
currentController = null
aggregator = null

buildRoutes = ->
  _.transform routeDefs, (r, [path, handler, options]) ->
    r[path] = buildRoute.call(this, path, handler, options)

buildRoute = (path, handler, options = {}) ->
  if _.isString(handler)
    [controllerName, fnName] = handler.split '#'
    controllerClass = require("controllers/#{controllerName}#{controllerSuffix}")
  else
    controllerClass = handler
    fnName = options

  unless controllerClass
    throw new Error "Cannot create route for unknown controller #{path}, #{handler}"
  unless _.isFunction(controllerClass::[fnName])
    throw new Error "Cannot create route for unknown controller function #{path}, #{handler}"

  return ->
    args = _.toArray(arguments)
    if @authenticated || options.public
      return @allowThrough(path, controllerClass, fnName, args)

    @app.session.authenticated (@authenticated) =>
      if @authenticated
        if @app.session.hasAcceptedLabsNotice()
          return @allowThrough(path, controllerClass, fnName, args)
        else
          @afterLogin ?= Backbone.history.fragment unless _.contains(['login', 'logout', 'labsNotice'], path)
          @navigate 'labsNotice', trigger: true, replace: true
      else
        @afterLogin ?= Backbone.history.fragment unless _.contains(['login', 'logout', 'labsNotice'], path)
        @navigate 'logout', trigger: true

module.exports = {

  addRoute: (path, handler, options = {}) ->
    if @router?
      buildRoute(path, handler, options)
    else
      routeDefs.push([path, handler, options])

  initialize: (config) ->

    aggregator = config.aggregator

    # handle default route by redirecting to full path
    routes[''] = ->
      @navigate appConfig.defaultRoute, trigger: true, replace: true

    @addRoute 'board', 'board#index'
    @addRoute 'board/:column', 'board#column'
    @addRoute 'board/:column/userstory/new', 'user_story_detail#storyForColumn'
    @addRoute 'board/:column/defect/new', 'defect_detail#defectForColumn'
    
    @addRoute 'userstories', 'home#userstories'
    @addRoute 'defects', 'home#defects'
    @addRoute 'tasks', 'home#tasks'

    @addRoute 'userstory/:id', 'user_story_detail#show'
    @addRoute 'userstory/:id/children', 'associations#childrenForStory'
    @addRoute 'userstory/:id/children/new', 'user_story_detail#childForStory'
    @addRoute 'userstory/:id/defects', 'associations#defectsForStory'
    @addRoute 'userstory/:id/defects/new', 'defect_detail#defectForStory'
    @addRoute 'userstory/:id/tasks', 'associations#tasksForStory'
    @addRoute 'userstory/:id/tasks/new', 'task_detail#taskForStory'
    @addRoute 'defect/:id', 'defect_detail#show'
    @addRoute 'defect/:id/tasks', 'associations#tasksForDefect'
    @addRoute 'defect/:id/tasks/new', 'task_detail#taskForDefect'
    @addRoute 'task/:id', 'task_detail#show'
    @addRoute 'portfolioitem/:id', 'portfolio_item_detail#show'
    @addRoute 'portfolioitem/:id/children', 'associations#childrenForPortfolioItem'
    @addRoute 'portfolioitem/:id/children/new', 'portfolio_item_detail#newChild'
    @addRoute 'portfolioitem/:id/userstories', 'associations#userStoriesForPortfolioItem'
    @addRoute 'portfolioitem/:id/userstories/new', 'user_story_detail#childForPortfolioItem'

    @addRoute 'new/userstory', 'user_story_detail#create'
    @addRoute 'new/task', 'task_detail#create'
    @addRoute 'new/defect', 'defect_detail#create'

    @addRoute 'login', 'auth#login', public: true
    @addRoute 'logout', 'auth#logout', public: true
    @addRoute 'labsNotice', 'auth#labsNotice'

    @addRoute 'settings', 'settings#show'
    @addRoute 'settings/board', 'settings#board'

    @addRoute ':type/:id/discussion', 'discussion#show'

    @addRoute 'recentActivity', 'recent_activity#show'

    @addRoute 'search', 'search#search'
    @addRoute 'search/:keywords', 'search#search'

    Router = Backbone.Router.extend
      routes: buildRoutes(routes)
      clientMetricsType: 'PageNavigationMetrics'

      onRoute: (path, options = {}) ->
        @navigate path, _.defaults(options, trigger: true)

      onChangeURL: (path, options = {}) ->
        @navigate path, _.defaults(options, trigger: false)

      allowThrough: (path, controllerClass, fnName, args) ->
        if @afterLogin? && path != @afterLogin && !_.contains(['login', 'logout', 'labsNotice'], path)
          path = @afterLogin
          @afterLogin = null

          @navigate path, trigger: true, replace: true
        else
          @execController(path, controllerClass, fnName, args)

      execController: (path, controllerClass, fnName, args) ->
        aggregator.startSession('Navigation', slug: path)
        aggregator.recordAction
          component: this
          description: "visited #{Backbone.history.location.pathname}"

        currentController?.dispose()
        currentController = new controllerClass()
        
        aggregator.beginLoad
          component: currentController
          description: "loading page"

        @listenToOnce currentController, 'controllerfinished', ->
          aggregator.endLoad component: currentController
          aggregator.recordComponentReady component: currentController
          
        currentController[fnName].apply(currentController, args)

      initialize: ->
        _.extend this, Messageable
        @subscribeEvent 'router:route', @onRoute
        @subscribeEvent 'router:changeURL', @onChangeURL
        @app = config.app
        @authenticated = false

    @router = new Router()
    routeDefs = null
}
