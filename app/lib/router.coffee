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
    @views = {}
    setTimeout =>
      @views.topbar = new TopbarView(router: @)
    , 1

  routes:
    '': 'home'
    'home': 'home'
    'login': 'login'
    'navigation': 'navigation'
    'settings': 'settings'
    'userstory/:id': 'userStoryDetail'
    'defect/:id': 'defectDetail'
    'task/:id': 'taskDetail'

  home: ->
    unless app.session.authenticated()
      @navigate 'login', trigger: true, replace: true
      return

    view = @views['home'] ?= new HomeView()
    @currentPage = 'home': view
    view.load()
    view.delegateEvents()

  userStoryDetail: (oid) ->
    unless app.session.authenticated()
      @navigate 'login', trigger: true, replace: true
      return

    @views['userStoryDetail'] ?= {}
    view = @views['userStoryDetail'][oid] ?= new UserStoryDetailView oid: oid, autoRender: true, el: $('#content')
    @currentPage = 'userStoryDetail': view
    view.render()
    view.delegateEvents()

  defectDetail: (oid) ->
    unless app.session.authenticated()
      @navigate 'login', trigger: true, replace: true
      return

    @views['defectDetail'] ?= {}
    view = @views['defectDetail'][oid] ?= new DefectDetailView oid: oid, autoRender: true, el: $('#content')
    @currentPage = 'defectDetail': view
    view.render()
    view.delegateEvents()

  taskDetail: (oid) ->
    unless app.session.authenticated()
      @navigate 'login', trigger: true, replace: true
      return

    @views['taskDetail'] ?= {}
    view = @views['taskDetail'][oid] ?= new TaskDetailView oid: oid, autoRender: true, el: $('#content')
    @currentPage = 'taskDetail': view
    view.render()
    view.delegateEvents()

  login: ->
    view = @views['login'] ?= new LoginView()
    @currentPage = 'login': view
    view.render()
    view.delegateEvents()

  navigation: ->
    view = @views['navigation'] ?= new NavigationView router: @
    @currentPage = 'navigation': view
    view.render()
    view.delegateEvents()

  settings: ->
    view = @views['settings'] ?= new SettingsView
    @currentPage = 'settings': view
    view.render()
    view.delegateEvents()

  # Overriding Navigate method to work on sliding around views
  # 'super' works because we are using CoffeeScript's 'extends' keyword
  navigate: (page, options) ->
    super
