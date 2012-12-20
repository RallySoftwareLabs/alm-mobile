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

    # Default page
    @currentPage = 'home'

    @views =
      topbar:
        new TopbarView router: @

    $(window).on 'hashchange', => @views['topbar'].render()

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

    @currentPage = 'home'
    @views['home'] ?= new HomeView()
    @views['home'].load()

  userStoryDetail: (oid) ->
    unless app.session.authenticated()
      @navigate 'login', trigger: true, replace: true
      return

    @currentPage = 'userStoryDetail'
    @views['userStoryDetail'] ?= {}
    @views['userStoryDetail'][oid] ?= new UserStoryDetailView oid: oid, autoRender: true, el: $('#content')
    @views['userStoryDetail'][oid].render()

  defectDetail: (oid) ->
    unless app.session.authenticated()
      @navigate 'login', trigger: true, replace: true
      return

    @currentPage = 'defectDetail'
    @views['defectDetail'] ?= {}
    @views['defectDetail'][oid] ?= new DefectDetailView oid: oid, autoRender: true, el: $('#content')
    @views['defectDetail'][oid].render()

  taskDetail: (oid) ->
    unless app.session.authenticated()
      @navigate 'login', trigger: true, replace: true
      return

    @currentPage = 'taskDetail'
    @views['taskDetail'] ?= {}
    @views['taskDetail'][oid] ?= new TaskDetailView oid: oid, autoRender: true, el: $('#content')
    @views['taskDetail'][oid].render()

  login: ->
    @topbarView.hide()

    @currentPage = 'login'
    @views['login'] ?= new LoginView()
    @views['login'].render()

  navigation: ->
    @currentPage = 'navigation'
    @views['navigation'] ?= new NavigationView router: @
    @views['navigation'].render()

  settings: ->
    @currentPage = 'settings'
    @views['settings'] ?= new SettingsView
    @views['settings'].render()

  # Overriding Navigate method to work on sliding around views
  # 'super' works because we are using CoffeeScript's 'extends' keyword
  navigate: (page, options) ->
    super
