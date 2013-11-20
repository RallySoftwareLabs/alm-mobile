define ->
  app = require 'application'
  utils = require 'lib/utils'
  Artifacts = require 'collections/artifacts'
  SiteController = require 'controllers/base/site_controller'
  SearchView = require 'views/search/search'

  class SearchController extends SiteController
    search: (params) ->
      keywords = decodeURIComponent(params.keywords || '')
      @whenLoggedIn ->
        artifacts = new Artifacts()
        @_fetchResults(artifacts, keywords) if keywords
        @view = @renderReactComponent(SearchView,
          collection: artifacts
          keywords: keywords
          region: 'main'
        )

        @listenTo @view, 'search', @onSearch

    onSearch: (keywords) ->
      @redirectTo "/search/#{encodeURIComponent(keywords)}"

    _fetchResults: (artifacts, keywords) ->
      artifacts.fetch
        data:
          fetch: 'ObjectID,FormattedID,Name,Ready,Blocked,ToDo'
          search: keywords
          project: app.session.get('project').get('_ref')
          projectScopeUp: false
          projectScopeDown: true
          order: 'ObjectID DESC'
        success: (collection, response, options) =>
          collection.remove collection.reject (model) -> _.contains(['HierarchicalRequirement', 'Task', 'Defect'], model.get('_type'))
