define ->
  app = require 'application'
  UserStories = require 'collections/user_stories'
  Tasks = require 'collections/tasks'
  Defects = require 'collections/defects'
  SiteController = require 'controllers/base/site_controller'
  HomeView = require 'views/home/home_view'
  UserStoriesPageView = require 'views/home/user_stories_page_view'
  TasksPageView = require 'views/home/tasks_page_view'
  DefectsPageView = require 'views/home/defects_page_view'

  class HomeController extends SiteController
    show: (params) ->
      @redirectToRoute 'home#userstories', replace: true

    userstories: (params) ->
      userStories = new UserStories()
      
      @whenLoggedIn ->
        @view = new UserStoriesPageView autoRender: true, tab: 'userstories', collection: userStories
        @listenTo @view, 'itemclick', @onItemClick
        userStories.fetch data: @getFetchData(['ObjectID', 'FormattedID', 'Name', 'Ready', 'Blocked'], """(((ScheduleState != "Completed") AND (ScheduleState != "Accepted")) AND (ScheduleState != "Released"))""")
      
    tasks: (params) ->
      tasks = new Tasks()

      @whenLoggedIn =>
        @view = new TasksPageView autoRender: true, tab: 'tasks', collection: tasks
        @listenTo @view, 'itemclick', @onItemClick
        tasks.fetch data: @getFetchData(['ObjectID', 'FormattedID', 'Name', 'Ready', 'Blocked', 'ToDo'], """(State != "Completed")""")

    defects: (params) ->
      defects = new Defects()

      @whenLoggedIn =>
        @view = new DefectsPageView autoRender: true, tab: 'defects', collection: defects
        @listenTo @view, 'itemclick', @onItemClick
        defects.fetch data: @getFetchData(['ObjectID', 'FormattedID', 'Name', 'Ready', 'Blocked'], """(((ScheduleState != "Completed") AND (ScheduleState != "Accepted")) AND (ScheduleState != "Released"))""")

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