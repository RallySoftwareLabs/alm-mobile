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
  'controllers/home_controller'
  'controllers/navigation_controller'
  'controllers/settings_controller'
  'controllers/discussion_controller'
  'controllers/user_story_detail_controller'
  'controllers/defect_detail_controller'
  'controllers/task_detail_controller'
  'controllers/board_controller'
  'controllers/recent_activity_controller'

], ($, Backbone, Bootstrap, app) ->

  $(->
    app.initialize()
  )
