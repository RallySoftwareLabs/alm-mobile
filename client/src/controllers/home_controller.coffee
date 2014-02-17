define ->
  app = require 'application'
  UserStories = require 'collections/user_stories'
  Tasks = require 'collections/tasks'
  Defects = require 'collections/defects'
  SiteController = require 'controllers/base/site_controller'
  HomeView = require 'views/home/home'

  class HomeController extends SiteController

    show: (params) ->
      @redirectTo 'userstories', replace: true

    userstories: (params) ->
      collection = new UserStories()
      
      @_fetchCollectionAndRender collection, 
          ['ObjectID', 'FormattedID', 'Name', 'Ready', 'Blocked'],
          """(((ScheduleState != "Completed") AND (ScheduleState != "Accepted")) AND (ScheduleState != "Released"))""",
          'userstories'
      
    tasks: (params) ->
      collection = new Tasks()

      @_fetchCollectionAndRender collection,
        ['ObjectID', 'FormattedID', 'Name', 'Ready', 'Blocked', 'ToDo'],
        """(State != "Completed")""",
        'tasks'

    defects: (params) ->
      collection = new Defects()

      @_fetchCollectionAndRender collection,
        ['ObjectID', 'FormattedID', 'Name', 'Ready', 'Blocked'],
        """(((ScheduleState != "Completed") AND (ScheduleState != "Accepted")) AND (ScheduleState != "Released"))""",
        'defects'

    _fetchCollectionAndRender: (collection, fetch, query, tab) ->
      @whenProjectIsLoaded =>
        collection.fetch(data: @_getFetchData(fetch, query)).always => @markFinished()
        @renderReactComponent(HomeView,
          tab: tab
          collection: collection
          listType: 'defect'
          changeOptions: 'sync'
          region: 'main'
        )

    _getFetchData: (fetch, query) ->
      data =
        fetch: fetch.join ','
        project: app.session.get('project').get('_ref')
        projectScopeUp: false
        projectScopeDown: true
        order: "Rank"
        query: query

      if app.session.isSelfMode()
        data.query = "(#{data.query} AND (Owner = #{app.session.get('user').get('_ref')}))"

      iterationRef = app.session.get('iteration')?.get('_ref')
      if iterationRef
        data.query = "(#{data.query} AND (Iteration = \"#{iterationRef}\"))"
      data