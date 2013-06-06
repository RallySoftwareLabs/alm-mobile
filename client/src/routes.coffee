define ->
  return (match) ->
    match '', 'home#show'
    match 'userstories', 'home#userstories'
    match 'defects', 'home#defects'
    match 'tasks', 'home#tasks'
    match 'login', 'auth#login'
    match 'navigation', 'navigation#show'
    match 'settings', 'settings#show'
    match ':type/:id/discussion', 'discussion#show'
    match 'userstory/:id', 'user_story_detail#show'
    match 'defect/:id', 'defect_detail#show'
    match 'task/:id', 'task_detail#show'
    match 'new/userstory', 'user_story_detail#create'
    match 'new/task', 'task_detail#create'
    match 'new/defect', 'defect_detail#create'
    match 'board', 'board#index'
    match 'board/:column', 'board#column'

#   class ALMRouter extends Backbone.Router

#     initialize: (@app) ->
#       @currentPage = {}
#       @views =
#         settings: new SettingsView
#           session: @app.session
#           router:  @

#       # wait until currentPage has been set
#       setTimeout =>
#         @views.topbar = new TopbarView
#           settings: @views.settings
#           router:   @
#       , 1

#     routes:
#       '': 'home'
#       'home': 'home'
#       'login': 'login'
#       'navigation': 'navigation'
#       'settings': 'settings'
#       ':type/:id/discussion': 'discussion'
#       'userstory/:id': 'userStoryDetail'
#       'defect/:id': 'defectDetail'
#       'task/:id': 'taskDetail'
#       'new/userstory' : 'newUserStory'
#       'new/task' : 'newTask'
#       'new/defect' : 'newDefect'

#     beforeAllFilters: ->
#       [
#         @authenticationFilter
#         @removeCurrentView
#       ]

#     authenticationFilter: (route, callback) ->
#       if @app.session.authenticated()
#         true
#       else
#         @navigate 'login', {trigger: false, replace: true}
#         @login()
#         false

#     removeCurrentView: ->
#       @_getCurrentView()?.remove()
#       true

#     home: ->
#       view = new HomeView()
#       @currentPage = 'home': view
#       $('#content').html(view.render().el)
#       view.delegateEvents()

#     userStoryDetail: (oid) ->
#       view = new UserStoryDetailView
#         session: @app.session
#         oid: oid
#         autoRender: true
#       @currentPage = 'userStoryDetail': view
#       $('#content').html(view.render().el)
#       view.delegateEvents()

#     defectDetail: (oid) ->
#       view = new DefectDetailView
#         session: @app.session
#         oid: oid
#         autoRender: true
#       @currentPage = 'defectDetail': view
#       $('#content').html(view.render().el)
#       view.delegateEvents()

#     taskDetail: (oid) ->
#       view = new TaskDetailView
#         session: @app.session
#         oid: oid
#         autoRender: true
#       @currentPage = 'taskDetail': view
#       $('#content').html(view.render().el)
#       view.delegateEvents()

#     discussion: (type, oid) ->
#       view = new DiscussionView
#         type: type
#         oid: oid
#       $('#content').html(view.render().el)
#       view.delegateEvents()

#     login: ->
#       view = @views['login'] ?= new LoginView(session: @app.session)
#       @currentPage = 'login': view
#       $('#content').html(view.render().el)
#       view.delegateEvents()

#     newUserStory: ->
#       view = new NewUserStoryView()
#       @currentPage = 'newUserStory' : view
#       $('#content').html(view.render().el)
#       view.delegateEvents()

#     newTask: ->
#       view = new NewTaskView()
#       @currentPage = 'newTask' : view
#       $('#content').html(view.render().el)
#       view.delegateEvents()

#     newDefect: ->
#       view = new NewDefectView()
#       @currentPage = 'newDefect' : view
#       $('#content').html(view.render().el)
#       view.delegateEvents()

#     navigation: ->
#       view = @views['navigation'] ?= new NavigationView router: @
#       @currentPage = 'navigation': view
#       $('#content').html(view.render().el)
#       view.delegateEvents()

#     settings: ->
#       view = @views['settings']
#       @currentPage = 'settings': view
#       $('#content').html(view.render().el)
#       view.delegateEvents()

#     # Overriding Navigate method to work on sliding around views
#     # 'super' works because we are using CoffeeScript's 'extends' keyword
#     navigate: (page, options) ->
#       super

#     _getCurrentView: ->
#       (view for key, view of @currentPage)[0]
