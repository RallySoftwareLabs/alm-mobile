define [
	'underscore'
	'application'
	'hbsTemplate'
	'views/base/page_view'
	'views/board/column_view'
], (_, app, hbs, PageView, ColumnView) ->

	class BoardView extends PageView
		region: 'main'
		className: 'board row-fluid'
		template: hbs['board/templates/board']

		initialize: (options = {}) ->
			super
			@columns = options.columns
			@field = options.field

			@updateTitle app.session.getProjectName()

		afterRender: ->
			_.map @columns, (col) =>
				colView = new ColumnView autoRender: true, model: col, container: "#col-#{col.get('value')}"
				@subview colView
				@bubbleEvent colView, 'click', 'columnClick'

		getTemplateData: ->
			columns: _.invoke @columns, _.getAttribute('value')