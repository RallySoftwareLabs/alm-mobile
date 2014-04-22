app = require 'application'
utils = require 'lib/utils'
Artifacts = require 'collections/artifacts'
SiteController = require 'controllers/base/site_controller'
SearchView = require 'views/search/search'

module.exports = class SearchController extends SiteController
  search: (keywords = '') ->
    @whenProjectIsLoaded ->
      artifacts = new Artifacts()
      @renderReactComponent(SearchView,
        collection: artifacts
        keywords: keywords
        region: 'main'
      )

      @subscribeEvent 'search', @onSearch
      if keywords
        @_fetchResults(artifacts, keywords)
      else
        @markFinished()

  onSearch: (keywords) ->
    @redirectTo "/search/#{encodeURIComponent(keywords)}"

  _fetchResults: (artifacts, keywords) ->
    artifacts.fetch
      data:
        fetch: 'FormattedID,Name,Ready,Blocked,ToDo'
        search: keywords
        project: app.session.get('project').get('_ref')
        projectScopeUp: false
        projectScopeDown: true
        order: 'ObjectID DESC'
      success: (collection, response, options) =>
        collection.remove collection.reject (model) -> _.contains(['HierarchicalRequirement', 'Task', 'Defect'], model.get('_type'))
        @markFinished()
