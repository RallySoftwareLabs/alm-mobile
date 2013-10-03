define ->
  app = require 'application'
  utils = require 'lib/utils'
  Artifacts = require 'collections/artifacts'
  SiteController = require 'controllers/base/site_controller'
  SearchView = require 'views/search/search_view'

  class SearchController extends SiteController
    search: (params) ->
      keywords = params.keywords || ''
      @whenLoggedIn ->
        @view = new SearchView
          region: 'main'
          autoRender: true
          collection: new Artifacts()
          keywords: keywords
          showLoadingIndicator: !!keywords

        @listenTo @view, 'search', @onSearch
        @listenTo @view, 'itemclick', @onItemClick

        @_fetchResults keywords if keywords

    onSearch: (keywords) ->
      @redirectTo "/search/#{encodeURIComponent(keywords)}"

    onItemClick: (url) ->
      @redirectTo url

    _fetchResults: (keywords) ->
      @view.collection.fetch
        data:
          fetch: 'ObjectID,FormattedID,Name,Ready,Blocked,ToDo'
          search: keywords
          project: app.session.get('project').get('_ref')
          projectScopeUp: false
          projectScopeDown: true
          order: 'ObjectID DESC'
        success: (collection, response, options) =>
          collection.remove collection.reject (model) -> _.contains(['HierarchicalRequirement', 'Task', 'Defect'], model.get('_type'))
          if collection.length == 0
            @view.displayNoSearchResults()
