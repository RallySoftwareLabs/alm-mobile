define ->
	_ = require 'underscore'
	hbs = require 'hbsTemplate'
	View = require 'views/base/view'
	ColumnViewMixin = require 'views/board/column_view_mixin'

	class ColumnView extends View
		template: hbs['board/templates/column']
		loadingIndicator: true
		abbreviateHeader: true
		showFields: false

		_.extend @prototype, ColumnViewMixin

		initialize: ->
		  super
		  @initializeMixin()
