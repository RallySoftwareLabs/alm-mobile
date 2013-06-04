define [
	'controllers/base/site_controller'
	'views/detail/defect_show_view'
	'views/detail/defect_create_view'
], (SiteController, ShowView, CreateView) ->
	class UserStoryDetailController extends SiteController
		show: (params) ->
			@view = new ShowView oid: params.id

		create: (params) ->
			@view = new CreateView