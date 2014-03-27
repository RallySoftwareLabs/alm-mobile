require 'jquery'
require 'backbone'
app = require 'application'
require 'backbone_mods'

  # required models
require 'models/user_story'

  # required controllers
require 'controllers/auth_controller'
require 'controllers/associations_controller'
require 'controllers/board_controller'
require 'controllers/defect_detail_controller'
require 'controllers/discussion_controller'
require 'controllers/home_controller'
require 'controllers/recent_activity_controller'
require 'controllers/search_controller'
require 'controllers/settings_controller'
require 'controllers/task_detail_controller'
require 'controllers/user_story_detail_controller'
require 'controllers/wall_controller'
require 'controllers/swimlane_wall_controller'
require 'controllers/portfolio_item_detail_controller'

if window.initializeApp
  $(document).ready ->
    app.initialize()
