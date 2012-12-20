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
    @topbarView = new TopbarView router: @
    $(window).on 'hashchange', => @topbarView.render()

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

    homeView = new HomeView().load()

  userStoryDetail: (oid) ->
    unless app.session.authenticated()
      @navigate 'login', trigger: true, replace: true
      return

    view = new UserStoryDetailView oid: oid, autoRender: true, el: $('#content')

  defectDetail: (oid) ->
    unless app.session.authenticated()
      @navigate 'login', trigger: true, replace: true
      return

    view = new DefectDetailView oid: oid, autoRender: true, el: $('#content')

  taskDetail: (oid) ->
    unless app.session.authenticated()
      @navigate 'login', trigger: true, replace: true
      return

    view = new TaskDetailView oid: oid, autoRender: true, el: $('#content')

  login: ->
    @topbarView.hide()
    loginView = new LoginView()
    loginView.render()

  navigation: ->
    navigationView = new NavigationView router: @
    navigationView.render()

  settings: ->
    settingsView = new SettingsView
    settingsView.render()

  # Overriding Navigate method to work on sliding around views
  # 'super' works because we are using CoffeeScript's 'extends' keyword
  navigate: (page, options) ->
    super
