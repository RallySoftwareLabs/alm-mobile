define [
  'application'
  'collections/user_stories'
  'collections/tasks'
  'collections/defects'
	'controllers/base/site_controller'
  'views/home/home_view'
  'views/home/user_stories_page_view'
  'views/home/tasks_page_view'
	'views/home/defects_page_view'
], (app, UserStories, Tasks, Defects, SiteController, HomeView, UserStoriesPageView, TasksPageView, DefectsPageView) ->
  class HomeController extends SiteController
    show: (params) ->
      @redirectToRoute 'home#userstories', replace: true

    userstories: (params) ->
      userStories = new UserStories()
      
      @view = new UserStoriesPageView autoRender: true, tab: 'userstories', collection: userStories

      @afterProjectLoaded =>
        userStories.fetch @getFetchData(['ObjectID', 'FormattedID', 'Name', 'Ready', 'Blocked'])
      
    tasks: (params) ->
      tasks = new Tasks()
      
      @view = new TasksPageView autoRender: true, tab: 'tasks', collection: tasks

      @afterProjectLoaded =>
        tasks.fetch @getFetchData(['ObjectID', 'FormattedID', 'Name', 'Ready', 'Blocked', 'ToDo'])

    defects: (params) ->
      defects = new Defects()
      
      @view = new DefectsPageView autoRender: true, tab: 'defects', collection: defects

      @afterProjectLoaded =>
        defects.fetch @getFetchData(['ObjectID', 'FormattedID', 'Name'])

    getFetchData: (fetch) ->
      data:
        fetch: fetch.join ','
        project: app.session.project.get('_ref')
        projectScopeUp: false
        projectScopeDown: true
        order: "CreationDate DESC,ObjectID"