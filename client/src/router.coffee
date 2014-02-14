define ->
  _ = require 'underscore'
  Backbone = require 'backbone'
  Messageable = require 'lib/messageable'

  controllerSuffix = '_controller'
  routes = {}
  currentController = null

  addRoute = (path, handler) ->
    [controllerName, fnName] = handler.split '#'
    controllerClass = require("controllers/#{controllerName}#{controllerSuffix}")
    unless controllerClass
      throw new Error "Cannot create route for unknown controller #{path}, #{handler}"
    unless _.isFunction(controllerClass::[fnName])
      throw new Error "Cannot create route for unknown controller function #{path}, #{handler}"

    routes[path] = ->
      currentController?.dispose()
      currentController = new controllerClass()
      view = currentController[fnName].apply(currentController, arguments)

  return {
    initialize: ->

      addRoute '', 'board#index'
      addRoute 'board', 'board#index'
      addRoute 'board/:column', 'board#column'
      addRoute 'board/:column/userstory/new', 'user_story_detail#storyForColumn'
      addRoute 'wall', 'wall#index'


      addRoute 'userstories', 'home#userstories'
      addRoute 'defects', 'home#defects'
      addRoute 'tasks', 'home#tasks'

      addRoute 'userstory/:id', 'user_story_detail#show'
      addRoute 'userstory/:id/children', 'associations#childrenForStory'
      addRoute 'userstory/:id/children/new', 'user_story_detail#childForStory'
      addRoute 'userstory/:id/defects', 'associations#defectsForStory'
      addRoute 'userstory/:id/defects/new', 'defect_detail#defectForStory'
      addRoute 'userstory/:id/tasks', 'associations#tasksForStory'
      addRoute 'userstory/:id/tasks/new', 'task_detail#taskForStory'
      addRoute 'defect/:id', 'defect_detail#show'
      addRoute 'defect/:id/tasks', 'associations#tasksForDefect'
      addRoute 'defect/:id/tasks/new', 'task_detail#taskForDefect'
      addRoute 'task/:id', 'task_detail#show'
      addRoute 'portfolioitem/:id', 'portfolio_item_detail#show'

      addRoute 'new/userstory', 'user_story_detail#create'
      addRoute 'new/task', 'task_detail#create'
      addRoute 'new/defect', 'defect_detail#create'

      addRoute 'login', 'auth#login'
      addRoute 'logout', 'auth#logout'
      addRoute 'labsNotice', 'auth#labsNotice'

      addRoute 'settings', 'settings#show'
      addRoute 'settings/board', 'settings#board'

      addRoute ':type/:id/discussion', 'discussion#show'

      addRoute 'recentActivity', 'recent_activity#show'

      addRoute 'search', 'search#search'
      addRoute 'search/:keywords', 'search#search'

      Router = Backbone.Router.extend
        routes: routes

        onRoute: (path, options = {}) ->
          @navigate path, _.defaults(options, trigger: true)

        onChangeURL: (path, options = {}) ->
          @navigate path, _.defaults(options, trigger: false)

        initialize: ->
          _.extend this, Messageable
          @subscribeEvent 'router:route', @onRoute
          @subscribeEvent 'router:changeURL', @onChangeURL

      router = new Router()

  }