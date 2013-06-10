define ->
	hbs = require 'hbsTemplate'
	View = require 'views/base/view'

	class ColumnView extends View
		template: hbs['board/templates/column']

		initialize: (options = {}) ->
			super
			@model.synced => @render()
			@delegate 'click', => @trigger 'click', @model

		getTemplateData: ->
			storiesAndDefects = @model.stories.toJSON().concat(@model.defects.toJSON())
			header = @model.get('value')[0] + (if @model.isSynced() then " (#{storiesAndDefects.length})" else " ...")
			data = 
				header: header
				cards: storiesAndDefects
