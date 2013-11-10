define ->
  app = require 'application'
  UserStories = require 'collections/user_stories'
  Tasks = require 'collections/tasks'
  Defects = require 'collections/defects'
  SiteController = require 'controllers/base/site_controller'
  HomeView = require 'views/home/home'

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
        @view = @renderReactComponent HomeView(
          tab: 'userstories'
          collection: userStories
          listType: 'userstory'
          changeOptions: 'synced'
          region: 'main'
        )
      
    tasks: (params) ->
      tasks = new Tasks()

      @whenLoggedIn =>
        tasks.fetch data: @getFetchData(
          ['ObjectID', 'FormattedID', 'Name', 'Ready', 'Blocked', 'ToDo'],
          """(State != "Completed")"""
        )
        @view = @renderReactComponent HomeView(
          tab: 'tasks'
          collection: tasks
          listType: 'task'
          changeOptions: 'synced'
          region: 'main'
        )

    defects: (params) ->
      defects = new Defects()

      @whenLoggedIn =>
        defects.fetch data: @getFetchData(
          ['ObjectID', 'FormattedID', 'Name', 'Ready', 'Blocked'],
          """(((ScheduleState != "Completed") AND (ScheduleState != "Accepted")) AND (ScheduleState != "Released"))"""
        )
        @view = @renderReactComponent HomeView(
          tab: 'defects'
          collection: defects
          listType: 'defect'
          changeOptions: 'synced'
          region: 'main'
        )

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