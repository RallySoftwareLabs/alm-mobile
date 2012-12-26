app = require 'application'

# required models
UserStory = require 'models/user_story'

# required views
TopbarView          = require 'views/topbar/topbar_view'
LoginView           = require 'views/login/login_view'
HomeView            = require 'views/home/home_view'
NavigationView      = require 'views/navigation/navigation_view'
SettingsView        = require 'views/settings/settings_view'
UserStoryDetailView = require 'views/detail/user_story_detail_view'
DefectDetailView    = require 'views/detail/defect_detail_view'
TaskDetailView      = require 'views/detail/task_detail_view'

module.exports = class ALMRouter extends Backbone.Router

  initialize: ->
    @currentPage = {}
    @views = {}

    # wait until currentPage has been set
    setTimeout =>
      @views.topbar = new TopbarView(router: @)
    , 1

    origRoute = Backbone.history.route

    Backbone.history.route = (route, callback) =>
      stop = false
      for filter in @beforeFilters
        unless filter.call(@, route, callback)
          stop = true
          break

      unless stop
        origRoute.call(@, route, callback)

  routes:
    '': 'home'
    'home': 'home'
    'login': 'login'
    'navigation': 'navigation'
    'settings': 'settings'
    'userstory/:id': 'userStoryDetail'
    'defect/:id': 'defectDetail'
    'task/:id': 'taskDetail'

  beforeFilters: ->
    [@authenticationFilter]

  authenticationFilter: (route, callback) ->
    if app.session.authenticated()
      true
    else
      @navigate 'login', {trigger: false, replace: true}
      @login()
      false

  home: ->
    @_getCurrentView()?.remove()

    view = @views['home'] ?= new HomeView()
    @currentPage = 'home': view
    $('#content').html(view.render().el)
    view.delegateEvents()

  userStoryDetail: (oid) ->
    @_getCurrentView()?.remove()

    @views['userStoryDetail'] ?= {}
    view = @views['userStoryDetail'][oid] ?= new UserStoryDetailView
      session: app.session
      oid: oid
      autoRender: true
    @currentPage = 'userStoryDetail': view
    $('#content').html(view.render().el)
    view.delegateEvents()

  defectDetail: (oid) ->
    @_getCurrentView()?.remove()

    @views['defectDetail'] ?= {}
    view = @views['defectDetail'][oid] ?= new DefectDetailView
      session: app.session
      oid: oid
      autoRender: true
    @currentPage = 'defectDetail': view
    $('#content').html(view.render().el)
    view.delegateEvents()

  taskDetail: (oid) ->
    @_getCurrentView()?.remove()

    @views['taskDetail'] ?= {}
    view = @views['taskDetail'][oid] ?= new TaskDetailView
      session: app.session
      oid: oid
      autoRender: true
    @currentPage = 'taskDetail': view
    $('#content').html(view.render().el)
    view.delegateEvents()

  login: ->
    @_getCurrentView()?.remove()
    view = @views['login'] ?= new LoginView(session: app.session)
    @currentPage = 'login': view
    $('#content').html(view.render().el)
    view.delegateEvents()

  navigation: ->
    @_getCurrentView()?.remove()
    view = @views['navigation'] ?= new NavigationView router: @
    @currentPage = 'navigation': view
    $('#content').html(view.render().el)
    view.delegateEvents()

  settings: ->
    @_getCurrentView()?.remove()
    view = @views['settings'] ?= new SettingsView
    @currentPage = 'settings': view
    $('#content').html(view.render().el)
    view.delegateEvents()

  # Overriding Navigate method to work on sliding around views
  # 'super' works because we are using CoffeeScript's 'extends' keyword
  navigate: (page, options) ->
    super

  _getCurrentView: ->
    (view for key, view of @currentPage)[0]
