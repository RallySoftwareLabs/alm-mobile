define [
  # required models
  'models/user_story'

  # required views
  'views/topbar/topbar_view'
  'views/login/login_view'
  'views/home/home_view'
  'views/navigation/navigation_view'
  'views/settings/settings_view'
  'views/detail/user_story_detail_view'
  'views/detail/defect_detail_view'
  'views/detail/task_detail_view'
  'views/new/new_user_story_view'
  'views/new/new_task_view'
  'views/new/new_defect_view'
  'views/discussion/discussion_view'
], (
  UserStory
  TopbarView
  LoginView
  HomeView
  NavigationView
  SettingsView
  UserStoryDetailView
  DefectDetailView
  TaskDetailView
  NewUserStoryView
  NewTaskView
  NewDefectView
  DiscussionView
) ->

  class ALMRouter extends Backbone.Router

    initialize: (@app) ->
      @currentPage = {}
      @views =
        settings: new SettingsView
          session: @app.session
          router:  @

      # wait until currentPage has been set
      setTimeout =>
        @views.topbar = new TopbarView
          settings: @views.settings
          router:   @
      , 1

    routes:
      '': 'home'
      'home': 'home'
      'login': 'login'
      'navigation': 'navigation'
      'settings': 'settings'
      ':type/:id/discussion': 'discussion'
      'userstory/:id': 'userStoryDetail'
      'defect/:id': 'defectDetail'
      'task/:id': 'taskDetail'
      'new/userstory' : 'newUserStory'
      'new/task' : 'newTask'
      'new/defect' : 'newDefect'

    beforeAllFilters: ->
      [
        @authenticationFilter
        @removeCurrentView
      ]

    authenticationFilter: (route, callback) ->
      if @app.session.authenticated()
        true
      else
        @navigate 'login', {trigger: false, replace: true}
        @login()
        false

    removeCurrentView: ->
      @_getCurrentView()?.remove()
      true

    home: ->
      view = new HomeView()
      @currentPage = 'home': view
      $('#content').html(view.render().el)
      view.delegateEvents()

    userStoryDetail: (oid) ->
      view = new UserStoryDetailView
        session: @app.session
        oid: oid
        autoRender: true
      @currentPage = 'userStoryDetail': view
      $('#content').html(view.render().el)
      view.delegateEvents()

    defectDetail: (oid) ->
      view = new DefectDetailView
        session: @app.session
        oid: oid
        autoRender: true
      @currentPage = 'defectDetail': view
      $('#content').html(view.render().el)
      view.delegateEvents()

    taskDetail: (oid) ->
      view = new TaskDetailView
        session: @app.session
        oid: oid
        autoRender: true
      @currentPage = 'taskDetail': view
      $('#content').html(view.render().el)
      view.delegateEvents()

    discussion: (type, oid) ->
      view = new DiscussionView
        type: type
        oid: oid
      $('#content').html(view.render().el)
      view.delegateEvents()

    login: ->
      view = @views['login'] ?= new LoginView(session: @app.session)
      @currentPage = 'login': view
      $('#content').html(view.render().el)
      view.delegateEvents()

    newUserStory: ->
      view = new NewUserStoryView()
      @currentPage = 'newUserStory' : view
      $('#content').html(view.render().el)
      view.delegateEvents()

    newTask: ->
      view = new NewTaskView()
      @currentPage = 'newTask' : view
      $('#content').html(view.render().el)
      view.delegateEvents()

    newDefect: ->
      view = new NewDefectView()
      @currentPage = 'newDefect' : view
      $('#content').html(view.render().el)
      view.delegateEvents()

    navigation: ->
      view = @views['navigation'] ?= new NavigationView router: @
      @currentPage = 'navigation': view
      $('#content').html(view.render().el)
      view.delegateEvents()

    settings: ->
      view = @views['settings']
      @currentPage = 'settings': view
      $('#content').html(view.render().el)
      view.delegateEvents()

    # Overriding Navigate method to work on sliding around views
    # 'super' works because we are using CoffeeScript's 'extends' keyword
    navigate: (page, options) ->
      super

    _getCurrentView: ->
      (view for key, view of @currentPage)[0]
