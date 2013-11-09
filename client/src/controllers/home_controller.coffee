define ->
  app = require 'application'
  UserStories = require 'collections/user_stories'
  Tasks = require 'collections/tasks'
  Defects = require 'collections/defects'
  SiteController = require 'controllers/base/site_controller'
  HomeView = require 'views/home/home_view'
  ListingView = require 'views/home/listing'
  TasksPageView = require 'views/home/tasks_page_view'
  DefectsPageView = require 'views/home/defects_page_view'

  class HomeController extends SiteController
    show: (params) ->
      @redirectToRoute 'home#userstories', replace: true

    userstories: (params) ->
      userStories = new UserStories()
      
      @whenLoggedIn ->
        userStories.fetch
          data: @getFetchData(
            ['ObjectID', 'FormattedID', 'Name', 'Ready', 'Blocked'],
            """(((ScheduleState != "Completed") AND (ScheduleState != "Accepted")) AND (ScheduleState != "Released"))"""
          )
        @view = @renderReactComponent ListingView(
          tab: 'userstories'
          collection: userStories
          listType: 'userstory'
          changeOptions: 'synced'
          region: 'main'
        )
        @listenTo @view, 'itemclick', @onItemClick
      
    tasks: (params) ->
      tasks = new Tasks()

      @whenLoggedIn =>
        tasks.fetch data: @getFetchData(
          ['ObjectID', 'FormattedID', 'Name', 'Ready', 'Blocked', 'ToDo'],
          """(State != "Completed")"""
        )
        @view = @renderReactComponent ListingView(
          tab: 'tasks'
          collection: tasks
          listType: 'task'
          changeOptions: 'synced'
          region: 'main'
        )
        @listenTo @view, 'itemclick', @onItemClick

    defects: (params) ->
      defects = new Defects()

      @whenLoggedIn =>
        defects.fetch data: @getFetchData(
          ['ObjectID', 'FormattedID', 'Name', 'Ready', 'Blocked'],
          """(((ScheduleState != "Completed") AND (ScheduleState != "Accepted")) AND (ScheduleState != "Released"))"""
        )
        @view = @renderReactComponent ListingView(
          tab: 'defects'
          collection: defects
          listType: 'defect'
          changeOptions: 'synced'
          region: 'main'
        )
        @listenTo @view, 'itemclick', @onItemClick

    onItemClick: (url) ->
      @redirectTo url

    getFetchData: (fetch, query) ->
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