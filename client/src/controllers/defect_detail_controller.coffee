define ->
	SiteController = require 'controllers/base/site_controller'
	ShowView = require 'views/detail/defect_show_view'
	CreateView = require 'views/detail/defect_create_view'

	class UserStoryDetailController extends SiteController
		show: (params) ->
			@view = new ShowView oid: params.id

		create: (params) ->
			@view = new CreateView autoRender: true