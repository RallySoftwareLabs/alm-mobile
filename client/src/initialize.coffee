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

  # required views
  # 'views/topbar/topbar_view'
  # 'views/auth/login_view'
  # 'views/home/home_view'
  # 'views/navigation/navigation_view'
  # 'views/settings/settings_view'
  # 'views/detail/user_story_detail_view'
  # 'views/detail/defect_detail_view'
  # 'views/detail/task_detail_view'
  # 'views/new/new_user_story_view'
  # 'views/new/new_task_view'
  # 'views/new/new_defect_view'
  # 'views/discussion/discussion_view'
], ($, Backbone, Bootstrap, app) ->

  $(->
    app.initialize()
    # $(document).on 'click', 'a:not([data-bypass])', (evt) ->

    #   href = $(this).attr('href')
    #   protocol = this.protocol + '//'

    #   if href.slice(protocol.length) isnt protocol
    #     evt.preventDefault()
    #     if href is '#back'
    #       window.history.back()
    #     else
    #       app.router.navigate(href, trigger: true)
  )
