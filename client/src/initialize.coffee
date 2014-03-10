require [
  'jquery'
  'backbone'
  'bootstrap'
  'application'
  'backbone_mods'

  # required models
  'models/user_story'

  # required controllers
  'controllers/auth_controller'
  'controllers/associations_controller'
  'controllers/board_controller'
  'controllers/defect_detail_controller'
  'controllers/discussion_controller'
  'controllers/home_controller'
  'controllers/recent_activity_controller'
  'controllers/search_controller'
  'controllers/settings_controller'
  'controllers/task_detail_controller'
  'controllers/user_story_detail_controller'
  'controllers/wall_controller'
  'controllers/swimlane_wall_controller'
  'controllers/portfolio_item_detail_controller'

], ($, Backbone, Bootstrap, app) ->
  app.initialize() if window.initializeApp
