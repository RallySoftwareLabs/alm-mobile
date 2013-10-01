define ->
  SiteController = require 'controllers/base/site_controller'
  ShowView = require 'views/detail/defect_show_view'
  CreateView = require 'views/detail/defect_create_view'

  class DefectDetailController extends SiteController
    show: (params) ->
      @whenLoggedIn ->
        @view = new ShowView oid: params.id

    create: (params) ->
      @whenLoggedIn ->
        @view = new CreateView autoRender: true