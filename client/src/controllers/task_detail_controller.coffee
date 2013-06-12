define ->
  SiteController = require 'controllers/base/site_controller'
  ShowView = require 'views/detail/task_show_view'
  CreateView = require 'views/detail/task_create_view'

  class TaskDetailController extends SiteController
    show: (params) ->
      @afterProjectLoaded ->
        @view = new ShowView oid: params.id

    create: (params) ->
      @afterProjectLoaded ->
        @view = new CreateView autoRender: true