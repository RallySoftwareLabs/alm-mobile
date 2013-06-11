define ->
  app = require 'application'
  utils = require 'lib/utils'
  UserStories = require 'collections/user_stories'
  Controller = require 'controllers/base/controller'
  NavigationView = require 'views/navigation/navigation_view'

  class NavigationController extends Controller

    constructor: ->
      super
      @view = new NavigationView region: 'navigation', autoRender: true
      @listenTo @view, 'navigate', @onNavigate
      @listenTo @view, 'search', @onSearch

    onNavigate: (newRoute) ->
      @view.hide()
      currentRoute = window.location.pathname

      unless newRoute == currentRoute || (newRoute == '' && _.contains(['/userstories', '/tasks', '/defects'], currentRoute))
        @redirectTo newRoute

    onSearch: (keyword) ->
      new UserStories().fetch
        data:
          fetch: "ObjectID,Name"
          search: keyword
          project: app.session.get('project').get('_ref')
          projectScopeUp: false
          projectScopeDown: true
        success: (collection, response, options) =>
          if collection.length > 0
            @view.hide()
            firstResult = collection.first()
            @redirectTo utils.getDetailHash(firstResult)
          else
            @view.displayNoSearchResults()