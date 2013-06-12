define ->
  SiteController = require 'controllers/base/site_controller'
  ShowView = require 'views/detail/defect_show_view'
  CreateView = require 'views/detail/defect_create_view'

  class DefectDetailController extends SiteController
    show: (params) ->
      @afterProjectLoaded ->
        @view = new ShowView oid: params.id

    create: (params) ->
      @afterProjectLoaded ->
        @view = new CreateView autoRender: true